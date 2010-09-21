HOST	=$(shell hostname)
ORG	=League of 20,000 Planets

vars:
	echo "HOST=${HOST}"

all::	${HOST}-key.pem

${HOST}-key.pem::
	certtool --generate-privkey >$@

all::	cacert.pem

cacert.pem::	ca.info cakey.pem
	certtool --generate-self-signed --load-privkey cakey.pem \
		--template ca.info --outfile cacert.pem
	${RM} ca.info

cakey.pem:
	certtool --generate-privkey >cakey.pem

ca.info:
	echo "cn=${ORG}"	 >$@
	echo "ca"		>>$@
	echo "cert_signing_key"	>>$@

clean::
	${RM} ca.info

distclean clobber:: clean
	${RM} cakey.pem
	${RM} cacert.pem

show::
	certtool -i --infile ca-cert.pem
