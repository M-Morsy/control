#' @title Transfer function model conversion to State-space model.
#'
#' @description
#' \code{tf2ss} converts the model for a transfer function to state-space representation
#'
#' @usage tf2ss(num, den)
#'
#'
#' @details
#' \code{tf2ss} converts a model object for a transfer function to a state-space model, Where \code{num} is the numerator and \code{den} is the denominator
#' of the transfer function and \code{sys} is a transfer function object
#'
#' Another possible call is \code{tf2ss(sys)} where \code{sys} is object of transfer-function model.
#'
#' @param num   A numeric vector containing the coefficients of the
# numerator in descending powers of s
#' @param den   A numeric vector containing the coefficients of the
# denominator in descending powers of s
#'
#'
#' @return Returns an object of 'ss' class.
#'
#' @seealso \code{\link{ss2tf}} \code{\link{tf2zp}}
#'
#' @examples
#' tf2ss(tf(1, c(1,2,1)))
#'
#' \dontrun{  OR }
#'
#' sys <- tf(1, c(1,2,1))
#' tf2ss(sys)
#'
#' \dontrun{  OR }
#'
#' sys2 <- tf2ss(1, c(1,2,1))
#'
#' @export

tf2ss <- function(num, den) {

  if (nargs() == 1)  {
    sys_tmp <- num
      if( class(sys_tmp) == 'tf') {
          sys <- unclass(sys_tmp)
          num <- sys$num
          den <- sys$den
      } else {
        stop("TF2SS: sys should be a transfer function model")
      }
  }

  # single variable systems
  if (is.vector(num) && is.vector(den)) {
    Dum <- tfchk(matrix(num, nrow = 1), matrix(den, nrow = 1))
    num <- Dum$numc
    den <- Dum$denc
  }

  if (is.matrix(num) && nrow(num) == 1) {
    Dum <- tfchk(matrix(num, nrow = 1), matrix(den, nrow = 1))
    num <- Dum$numc
    den <- Dum$denc
    #multiple output systems
  } else if (is.matrix(num) && nrow(num) > 1){
    num <- num
    den <- den
  }

  tmpden <- den
  den_rows <- nrow(den)
  n    <- ncol(den)

  if ( ncol(den) == 0 && ncol(num) == 0 ) {
    return( ss( A = c(), B = c(), C = c(), D = c() ) )
  }

  idx <- which(den != 0)
  den <- den[idx[1]:n]
  den_rows <- nrow(den)
     n <- ncol(tmpden)

  num_rows <- nrow(num)
  num_cols <- ncol(num)

  if (num_cols > n) {

    if (all (all (num[ , 1:(num_cols - n)] == 0) ) ) {
      num <- num[ , (num_cols - n + 1) : num_cols]
      num_rows <- nrow(num)
      num_cols <- ncol(num)
    } else {
      stop("TF2SS: The order of the Numerator should be equal or lesser than the Denominator.")
    }

  }
  num <- cbind( matrix(0, num_rows, n - num_cols), num) / den[1]

  if (length(num)) {
    d <- as.matrix(num[,1])
  } else {
    d <- as.matrix(c())
  }

  if (n == 1) {
    syss <- list(A = as.matrix(0), B = as.matrix(0), C = as.matrix(0), D = d)
    class(syss) <- 'ss'
    return(syss)
  }

  den <- den[2:n] / den[1]
  a <- rbind(-den, diag(1, n-2, n-1) )
  b <- diag(1, n-1, 1)

  if (num_rows > 0) {
    c <- as.matrix(num[ , 2:n] - num[ , 1] * den)

      if (ncol(c) == 1){
       c <- t(c)
      }

  } else {
    c <- c()
  }

  sys1 <- list(A = a, B = b, C = c, D = d)
  class(sys1) <- "ss"
  return(sys1)
}
