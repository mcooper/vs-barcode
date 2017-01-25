setwd("D:/Documents and Settings/mcooper/GitHub/vs-data-tools/anonymize data/")

pii <- read.csv('pii fields.csv')

pii <- pii[pii$encrypt.=='yes', ]

alter <- '--Run once just to alter the schema and add encryption columns\n\n'
encrypt <- '--Run this script to encrypt columns with people\'s names and then erase those columns\n--CTRL-F to change PASSWORD to the appropriate word (Matt has it in his LastPass)\n\n'
decrypt <- '--Run this script to fill the pii columns with the appropriate info,\n--using CTRL-F to replace PASSWORD with the appropriate word (Matt has it in his LastPass)\n\n'

for (i in 1:nrow(pii)){
  alter <- paste0(alter, 'ALTER TABLE "', pii$table[i], '" ADD COLUMN ',  pii$var[i], '_cpt bytea;\n\n')
  encrypt <- paste0(encrypt, 'UPDATE "', pii$table[i], '"\nSET ', pii$var[i], '_cpt = pgp_sym_encrypt(', pii$var[i], ", 'PASSWORD'),\n", pii$var[i], "=NULL\nWHERE ", pii$var[i], " IS NOT NULL;\n\n")
  decrypt <- paste0(decrypt, 'UPDATE "', pii$table[i], '"\nSET ', pii$var[i], ' = pgp_sym_decrypt(', pii$var[i], "_cpt, 'PASSWORD'),\n", pii$var[i], "_cpt=NULL\nWHERE ", pii$var[i], "_cpt IS NOT NULL;\n\n")
}

cat(alter, file='alter.sql')
cat(encrypt, file='encrypt.sql')
cat(decrypt, file='decrypt.sql')