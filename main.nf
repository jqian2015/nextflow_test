

include { test1 } from './workflows/test1.nf'
include { test2 } from './workflows/test2.nf'



workflow  {
    test1()
    test2()
}
