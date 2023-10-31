#
# Copyright (C) 2013-2018 University of Amsterdam
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#

SummaryStatsBayesFactorFunctions <- function(jaspResults, dataset = NULL, options, ...) {

  dataset <- .bFFReadDataFromOptions(options)
  saveRDS(options, file = "C:/JASP/options.RDS")
  saveRDS(dataset, file = "C:/JASP/dataset.RDS")


  return()
}


.bFFDependencies <- c(
  "none"
)
.bFFReadDataFromOptions <- function(options) {

  theta    <- options[["estimate"]][[1]][["values"]]
  varTheta <- do.call(cbind, lapply(options[["variance"]], function(col) col[["values"]]))

  # fill lower triangle
  varTheta[lower.tri(varTheta)] <- t(varTheta)[lower.tri(varTheta)]

  if (any(eigen(varTheta)$values < 0))
    stop(gettext("The specified variance matrix is not a valid covariance matrix (not positive semi-definite)."))

  return(list(
    theta    = theta,
    varTheta = varTheta
  ))
}
