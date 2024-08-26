(define-module (oposs packages perl)
  #:use-module (guix)
  #:use-module (guix git-download)
  #:use-module (guix build utils)
  #:use-module (guix build-system gnu)
  #:use-module (guix build-system perl)
  #:use-module (gnu packages autotools)
  #:use-module (gnu packages compression)
  #:use-module (gnu packages tls)
  #:use-module (gnu packages perl)
  #:use-module (gnu packages wget)
  #:use-module ((guix licenses) #:prefix license:))

(define-public perl-convert-asn1
  (package
    (name "perl-convert-asn1")
    (version "0.33")
    (source
     (origin
       (method url-fetch)
       (uri (string-append
             "mirror://cpan/authors/id/T/TI/TIMLEGGE/Convert-ASN1-" version
             ".tar.gz"))
       (sha256
        (base32 "0xk0s2rnwjb7ydhwfinpjcbw25im54b8cs7r9hj3m7n7412h1pqz"))))
    (build-system perl-build-system)
    (home-page "https://metacpan.org/dist/Convert-ASN1")
    (synopsis
     "Abstract Syntax Notation One encoding and decoding library for Perl")
    (description
     "Convert::ASN1 is the Perl library for ASN1 encoding and decoding")
    (license license:perl-license)))

(define-public perl-net-ssleay-1.94
  (package
    (inherit perl-net-ssleay)
    (name "perl-net-ssleay-1.94")
    (version "1.94")
    (source
     (origin
       (method url-fetch)
       (uri (string-append "mirror://cpan/authors/id/C/CH/CHRISN/Net-SSLeay-"
                           version ".tar.gz"))
       (sha256
        (base32 "0pfrpi77964cg15dm6y0w03l64xs0k2nqc15qh2xmv8vdnjyhywx"))))
    (build-system perl-build-system)))

(define-public perl-crypt-openssl-x509
  (package
    (name "perl-crypt-openssl-x509")
    (version "2.0.1")
    (source
     (origin
       (method url-fetch)
       (uri (string-append
             "mirror://cpan/authors/id/J/JO/JONASBN/Crypt-OpenSSL-X509-"
             version ".tar.gz"))
       (sha256
        (base32 "19iz7ca4v5fw81jmf54r0kpwy5zralp2r9qh3aa0x8cyhd7q4i1k"))))
    (build-system perl-build-system)
    (native-inputs (list perl-convert-asn1 perl-crypt-openssl-guess))
    (inputs (list perl-module-install perl-crypt-openssl-bignum
                  perl-crypt-openssl-random openssl))
    (arguments
     (@@ (gnu packages tls) perl-crypt-arguments))
    (home-page "https://metacpan.org/release/JONASBN/Crypt-OpenSSL-X509-2.0.1")
    (synopsis
     "x509 public key certificate formatting for Perl using OpenSSL libraries")
    (description
     "Crypt::OpenSSL::x509 is the Perl extension to OpenSSL's X509 API.")
    (license license:perl-license)))

(define-public acmefetch
  (package
    (name "acmefetch")
    (version "0.8.1")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/oetiker/AcmeFetch")
             (commit (string-append "v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "0lamwdm76mmxr9awhfwamp0fgadacjl8yrhj25wdlgjr96czqbz5"))))
    (build-system gnu-build-system)
    (native-inputs (list autoconf automake))
    (inputs (list perl
                  perl-crypt-openssl-x509
                  unzip
                  openssl
                  wget))
    (arguments
     (list
      #:phases #~(modify-phases %standard-phases
                   (add-before 'bootstrap 'patch-disable-web-scraper
                     (lambda _
                       (substitute* "Makefile.am"
                         (("SUBDIRS = thirdparty etc")
                          "SUBDIRS = etc")))))))
    (synopsis "Generate and manage LetsEncrypt certificates")
    (description
     "AcmeFetch is a thin wrapper arount the Net::ACME2 library to
fetch and maintain ssl certificates using the the services of Let's
Encrypt")
    (home-page "https://www.oetiker.ch")
    (license license:gpl3+)))
