convt2list <- function(dat, keep_par_names = FALSE) {
  if (is.data.frame(dat)) {
    unname(by(dat, 1:nrow(dat), mklst, keep_par_names))
  } else {
    dat
  }
}


has_gradable_files <- function(student_dir,
                               conform_Naming = NULL,
                               Rscript = TRUE,
                               Rmd = TRUE,
                               pdf_or_html = TRUE) {
  options(warn = -1)
  files_required <- c(Rscript, Rmd, pdf_or_html)
  regx <- c("R", "Rmd", "pdf|html")[files_required]
  cnt <-
    sum(files_required) # # of files -> max of 3 ie R, Rmd, html|pdf
  if (!cnt)
    stop("at least one document must be specified")
  regx <- paste0("\\.(", paste0(regx, collapse = "|"), ")$")
  sfiles <- list.files(
    student_dir,
    pattern = regx,
    recursive = TRUE,
    ignore.case = TRUE,
    full.names = TRUE
  )
  id <- basename(dirname(sfiles))
  has_files <- grepl(regx, sfiles, ignore.case = TRUE)
  result <- data.frame(id, has_files,
                       row.names = NULL)
  if (!is.null(conform_Naming)) {
    result$check_nm <- grepl(conform_Naming,
                             sub(regx, "", basename(sfiles), ignore.case = TRUE))
  }
  options(warn = 0)
  aggregate(. ~ id, result, function(x)
    sum(x) == cnt)
}

is_knittable_Rmd <- function(student_dir) {
  student_dir <- gsub("\\\\", "/", normalizePath(student_dir))
  options(warn = -1)
  start <- names(.GlobalEnv)
  new_dir <- paste0(getwd(), "/Rmd_files_knit")
  new_file <- file.path(getwd(), "is_knitable_results.txt")
  if (file.exists(new_file)) {
    file.remove(new_file)
  }
  file.create(new_file)

  student_files <- list.files(
    student_dir,
    "\\.Rmd",
    recursive = TRUE,
    ignore.case = TRUE,
    full.names = TRUE
  )
  ID <-
    sub("/.*", "", sub(paste0(student_dir, "/*"), "", dirname(student_files)))
  is_knitable <-c()
    for( i in seq_along(student_files)) {
      avail_pkgs <- search()
      nms1 <- ls(envir = parent.frame())
      is_knitable[i] <- knit(student_files[i],new_dir, new_file)
      rm(list = setdiff(ls(), nms1),envir = parent.frame())
      sapply(setdiff(search(), avail_pkgs), detach, character.only = TRUE)
      }
  unlink(new_dir, TRUE, TRUE)
  cat("the comments have been written to ", new_file)
  rm(list = setdiff(names(.GlobalEnv), start), envir = .GlobalEnv)
  options(warn = 0)
  data.frame(ID, is_knitable)
}

no_functions_in_Rmd <- function(student_dir) {
  sfiles <- list.files(
    student_dir,
    "\\.Rmd$",
    full.names = TRUE,
    recursive = TRUE,
    ignore.case = TRUE
  )
  ID <- sub(".*/", "", dirname(sfiles))
  data.frame(ID,
             has_no_functions = sapply(sfiles, has_no_function),
             row.names = NULL)
}

has_no_function <- function(path) {
  lns <- suppressWarnings(readLines(path))
  idx <- grep("```", lns, fixed = TRUE)
  R_chunks_idx <- match(grep("```\\{r.*?\\}", lns), idx)
  search_idx <-
    unlist(Map(":", idx[R_chunks_idx], idx[R_chunks_idx + 1]))
  ! any(grepl("(?:(?:<-)|=)\\s*function\\(.*?\\)", lns[search_idx]))
}

uid_as_seed_1 <- function(path) {
  seed <- sprintf("set.seed(%s)", sid<-basename(path))
  Rmd <-
    list.files(path, pattern = "\\.[Rr][Mm][Dd]$", full.names = TRUE)[1]
  R <- list.files(path, pattern = "\\.[Rr]$", full.names = TRUE)[1]
  if (is.na(Rmd) | is.na(R)) {
    return("Does not have the files")
  }
  lns <- suppressWarnings(readLines(Rmd))
  idx <- grep("```", lns, fixed = TRUE)
  R_chunks_idx <- match(grep("```\\{r.*?\\}", lns), idx)
  if (length(idx) %% 2 != 0)
    check <- c(lns, suppressWarnings(readLines(R)))
  else {
    search_idx <-
      unlist(Map(":", idx[R_chunks_idx], idx[R_chunks_idx + 1]))
    check <- c(lns[search_idx], suppressWarnings(readLines(R)))
  }
  d <- grep("set.seed", check, value = TRUE)
  res <- all(grepl(seed, d, fixed = TRUE))
  if (res)
    res
  else {
    n <- gsub("\\D+","",unique(d))
    if(any(nchar(n[n != sid ])==9)) toString(n)
    else grepl(sid, toString(n))
  }
}

uid_as_seed <- function(student_dir) {
  pths <- list.dirs(student_dir,recursive = FALSE)
  if(length(pths) == 0) pths <- student_dir
  data.frame(
    UID = basename(pths),
    uid_as_seed = sapply(pths, uid_as_seed_1, USE.NAMES = FALSE)
  )
}


has_data_1 <- function(path, data_name, mode, check) {
  cat("checking ",data_name, "in", basename(path),"\n")
  if (missing(mode))
    stop(sprintf("Indicate the mode of your %s", data_name), call. = FALSE)
  std_env <- new.env()
  Rmd <-
    list.files(path, pattern = "\\.[Rr][Mm][Dd]$", full.names = TRUE)[1]
  R <- list.files(path, pattern = "\\.[Rr]$", full.names = TRUE)[1]
  if (is.na(Rmd) | is.na(R)) {
    return("Does not have the files")
  }
  if (!has_install(R)) {
    suppressMessages(
      suppressWarnings(
        capture.output(a <- try(source(R, std_env), silent = TRUE)
    )))
    if(inherits(a,"try-error")) return(" Cannot Source")
  }
  else
    return("Installing package. Cannot check")
  if (exists(data_name, std_env, mode = mode, inherits = FALSE)) {
    return(check_fn(get(data_name, std_env), check))
  }
  else{
    lns <- suppressMessages(suppressWarnings(readLines(Rmd)))
    if (has_install(Rmd))
      return("installing a package. Cannot Run the markdown")
    idx <- grep("```", lns, fixed = TRUE)
    betwn <- grep(sprintf("%s\\s*(?:(?:<-)|=)", data_name), lns)[1]

    wch <- which.max(betwn < idx)
    sq <- try(seq(idx[wch - 1] + 1, idx[wch] - 1), silent = TRUE)
    if (inherits(sq, "try -error"))
      return(FALSE)
    pth <- sub("source\\(\"",sprintf("source(\"%s/", gsub("\\\\","/",path)),lns[sq])
    s <- tempfile()
    cat(pth, file = s, sep ="\n")
    aa<- try({
      setTimeLimit(5, transient = TRUE)
      suppressWarnings(suppressPackageStartupMessages(capture.output(
      source(s, std_env))))}
      , silent = TRUE)
    if(inherits(aa,"try-error")) return(FALSE)
    if(exists(data_name, std_env, mode = mode, inherits = FALSE)){
      return(check_fn(get(data_name, std_env), check))
    }
    else FALSE
  }
}


check_fn <- function(dat, chks) {
  if(length(chks) == 0) return(TRUE)
  nm <- names(chks)
  if(is.null(nm)) idx <- logical(length(chks))
  else idx <- nm != ""
  a <- TRUE
  if (any(idx)) {
    Fun1 <- function(x, y) {
        all(do.call(`%in%`, list( eval.parent(y), match.fun(x)(dat))))
    }
    a <- mapply(Fun1, nm[idx], chks[idx])
  }

  # idx1 <- lengths(lapply(chks[which(!idx)], function(x)as.list(x[[2]]))) > 1
  # if (any(idx1))
  #   a<- c(a, sapply(chks[idx1], function(x)all(eval(x, list(x = dat)))))
  # idx <- idx1|idx

  Fun <- function(x) {
    x[[2]] <- call(deparse(x[[2]]), dat)
    all(eval.parent(x))
  }
  all(c(a, vapply(chks[which(!idx)], Fun, logical(1))))
}

has_data <- function(student_dir, data_name, mode, check = alist()){
  lst <- list.dirs(student_dir,recursive = FALSE)
  if(length(lst) == 0) lst <- student_dir
  vals <- c()
  for (i in seq_along(lst)){
    avail_pkgs <- search()
    vals[i] <- has_data_1(lst[i], data_name, mode, check)
    sapply(setdiff(search(), avail_pkgs), detach, character.only = TRUE)
  }
  data.frame(ID = basename(lst), has_data = vals, row.names = NULL)
}
