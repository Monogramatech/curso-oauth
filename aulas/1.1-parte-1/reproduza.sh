#!/usr/bin/env bash
# Aula 1.1, Parte 1: Base64url não é segurança: codificação, hash e cifra.
# Reproduz o laboratório desta parte. Antes, uma vez: bash laboratorio/preparo.sh
#   bash aulas/1.1-parte-1/reproduza.sh
source "$(dirname "$0")/../../laboratorio/comum.sh"
login_lab
# O corpo do token, decodificado: qualquer um lê
echo; echo "== O corpo do token, decodificado: qualquer um lê"
node -e "console.log(Buffer.from(process.argv[1].split('.')[1],'base64url').toString())" "$T"
# Base64url: ida e volta
echo; echo "== Base64url: ida e volta"
node -e "console.log(Buffer.from('OAuth').toString('base64url'), Buffer.from('T0F1dGg','base64url').toString())"
# SHA-256 de duas palavras quase iguais
echo; echo "== SHA-256 de duas palavras quase iguais"
node -e "const c=require('crypto');for(const s of ['token','tokens'])console.log(s,c.createHash('sha256').update(s).digest('hex'))"
# PKCE: o challenge é o SHA-256 do verifier (V e CH do passo 3 da Aula 0.2)
echo; echo "== PKCE: o challenge é o SHA-256 do verifier (V e CH do passo 3 da Aula 0.2)"
printf %s "$V" | openssl dgst -sha256 -binary | openssl base64 -A | tr '+/' '-_' | tr -d '='; echo; echo "$CH"
# AES-256-GCM: cifra e decifra com a mesma chave
echo; echo "== AES-256-GCM: cifra e decifra com a mesma chave"
node -e "const c=require('crypto'),k=c.randomBytes(32),iv=c.randomBytes(12),x=c.createCipheriv('aes-256-gcm',k,iv),e=Buffer.concat([x.update('OAuth'),x.final()]),d=c.createDecipheriv('aes-256-gcm',k,iv);d.setAuthTag(x.getAuthTag());console.log(e.toString('base64url'),Buffer.concat([d.update(e),d.final()]).toString())"
# RSA-OAEP: a pública cifra, a privada decifra
echo; echo "== RSA-OAEP: a pública cifra, a privada decifra"
node -e "const c=require('crypto'),p=c.generateKeyPairSync('rsa',{modulusLength:2048}),e=c.publicEncrypt(p.publicKey,Buffer.from('OAuth'));console.log(e.length+' bytes',c.privateDecrypt(p.privateKey,e).toString())"
