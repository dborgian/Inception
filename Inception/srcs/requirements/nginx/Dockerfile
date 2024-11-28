FROM alpine:3.19

RUN apk update && apk upgrade
RUN apk --no-cache add nginx openssl

# Cre cartella per i file temporanei di nginx e i file strani di nginx
RUN mkdir -p /run/nginx
RUN mkdir -p /etc/nginx/ssl

RUN     openssl req -newkey rsa:2048 \ 
       # creando un certificato auto-firmato X.509
        -x509 \
        #. SHA-256 è un algoritmo di hashing sicuro 
        -sha256 \
        # validità del certificato auto-firmato
        -days 365 \
        # significa che la chiave privata non dovrebbe essere protetta e criptata con una passphrase
        -nodes \
        -keyout /etc/nginx/ssl/dborgian.key \
        -out /etc/nginx/ssl/dborgian.crt \
        #Questa parte imposta i dettagli del soggetto del certificato:
        -subj "/C=IT/ST=Italy/L=Rome/O=42Rome/OU=$USER/CN=$USER"
COPY    /conf/nginx.conf  /etc/nginx/http.d/nginx.conf

EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]