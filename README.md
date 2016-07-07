# vs-barcode
A python script to create barcodes for Vital Signs soil samples and log those that have already been used

Its designed to be run from the command line with three arguments: The country, the number of desired barcodes, and the protocol (either FFS or Eplot)

For example:
`python barcode_gen.py Rwanda 55 FFS`

This will create a PDF in your directory with all of the barcodes, designed for use in the field.