       01  ADDRESS.
           05 ADDRESS-LINE-1         PIC X(40).
           05 ADDRESS-LINE-2.
              10 CITY                PIC X(17).
              10 STATE               PIC XX.
              10 FILLER              PIC X.
              10 ZIP1                PIC 9(5).
              10 FILLER              PIC X
                   VALUE IS "-".
              10 ZIP2                PIC 9(4).
