#let __DEBUG_AUTHOR_TABLE = state("$ktu-template-DEBUG_AUTHOR_TABLE", false)
#let debug-author-table() = {
    __DEBUG_AUTHOR_TABLE.update(true)
}

#let __HEADING_EXPERIMENT = state("$ktu-template-HEADING_EXPERIMENT", false)
#let enable-heading-experiment() = {
    __HEADING_EXPERIMENT.update(true)
}
