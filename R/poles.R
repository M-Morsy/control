#' @title Obtain Poles for a System
#'
#'
#' @description  This function obtains the poles for a given system
#'
#' @details  \code{pole} returns the poles for a given system either a transfer function,
#' state-space or zero-pole models. If sys is a transfer function, it computes the roots of the denominator
#' If sys is a state-space object, it computes the eigenvalues of the A matrix.
#' If sys is a zpk object, it retrieves the poles from the object.
#'
#' @param sys LTI system of tf, ss and zpk class
#'
#' @return The function returns a column matrix containing the poles for the given system
#'
#' @examples
#' H1 <- tf(c(2, 5, 1),c(1, 3, 5))
#' pole(zpk(NULL, c(-1,-1), 1))
#' pole(ssdata(tf(1, c(1,2,1))))
#'
#' @export
pole <- function(sys) {
  if (class(sys) == 'tf') {
    res <- pracma::roots(c(sys[[2]]))
    return(as.matrix(res))
  }
  if (class(sys) == 'ss') {
    res <- eigen(sys[[1]])$values
    return(as.matrix(res))
  }
  if (class(sys) == 'zpk') {
    res <- sys[[2]]
    return(as.matrix(res))
  }
  if(is.vector(sys)){
    res <- pracma::roots(sys)
    return(as.matrix(res))
  }
}
