# Cómo obtener los secretos del workflow de deploy

Guía paso a paso para conseguir los valores listados en [secrets.github-action.example](secrets.github-action.example)
y cargarlos como secretos del repositorio en GitHub Actions
(Settings > Secrets and variables > Actions > New repository secret).

## DOCKERHUB_USERNAME

La cuenta/organización de Docker Hub bajo la que se publica la imagen de
ticket-hub. Se usa para armar la URL de la imagen a desplegar
(`$DOCKERHUB_USERNAME/ticket-hub:$IMAGE_TAG`) y para consultar si el tag
existe antes de desplegar.

1. Es el username que figura en tu perfil de [Docker Hub](https://hub.docker.com/)
   (o el nombre de la organización dueña del repositorio de imágenes).
2. Tiene que ser el mismo valor que `DOCKERHUB_USERNAME` en `ticket-hub`.
3. Guardalo como `DOCKERHUB_USERNAME`.

## KUBECONFIG_MICROK8S

El kubeconfig que le permite a `kubectl` autenticarse contra el clúster de
microk8s corriendo en el servidor pcbox, alcanzable por la red de Tailscale.

1. Conectate por SSH al servidor (el que tiene microk8s instalado).
2. Generá el kubeconfig con `microk8s config`.
3. El campo `server:` que trae por defecto apunta a una IP local del host
   (por ejemplo `127.0.0.1` o la IP de la LAN) — reemplazalo por el nombre o
   la IP de Tailscale del servidor (la que ves con `tailscale status` o en
   la [consola de admin de Tailscale](https://login.tailscale.com/admin/machines)),
   así el runner de GitHub Actions lo puede resolver una vez unido a la
   tailnet.
4. Si `kubectl` rechaza el certificado del API server por el cambio de
   `server:`, hay que regenerar el certificado del API server incluyendo esa
   IP/hostname como SAN (`microk8s refresh-certs --cert-name server.crt`,
   agregando el SAN correspondiente antes de confirmar).
5. Copiá el contenido completo del archivo resultante y guardalo como
   `KUBECONFIG_MICROK8S`.

> El paso "Verificar que el clúster de microk8s sea accesible" (`kubectl get
> nodes`) en el workflow es justamente la validación de que este secreto y
> la conexión de Tailscale están bien configurados.

## TS_OAUTH_CLIENT_ID / TS_OAUTH_SECRET

Las credenciales que usa [tailscale/github-action](https://github.com/tailscale/github-action)
para unir el runner a la tailnet como nodo efímero con el tag
`tag:continuous-integration`, y así poder llegar al servidor pcbox.

1. Entrá a la [consola de admin de Tailscale](https://login.tailscale.com/admin/settings/oauth) > Settings > OAuth clients > Generate OAuth client.
2. Scopes: seleccioná **Devices Core** con permiso de escritura (`write`),
   necesario para que el runner se pueda registrar como nodo.
3. Tags: asigná `tag:continuous-integration` — tiene que ser el mismo tag
   que usa el step `Unirse a la red de Tailscale` del workflow.
4. Generá el cliente y copiá el **Client ID** y el **Client Secret** apenas
   se muestren — el secret solo se ve una vez.
5. Guardalos como `TS_OAUTH_CLIENT_ID` y `TS_OAUTH_SECRET` respectivamente.

> Si el join a la tailnet falla con un error de tags no permitidos,
> `tag:continuous-integration` tiene que estar declarado en `tagOwners`
> dentro de la [ACL policy](https://login.tailscale.com/admin/acls) de la
> tailnet, y el OAuth client necesita permiso para asignarlo.
