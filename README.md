## Instalar docker

- [Linux](https://docs.docker.com/install/)

- [Windows](https://docs.docker.com/docker-for-windows/install/)

- [Mac](https://docs.docker.com/docker-for-mac/install/)


## Convención de versión
De acuerdo al estandar https://semver.org/lang/es/ se debe contemplar dos número para xx (10) y para y (5) en el caso de laravel 

Ejemplo:
10.5

En el caso de PHP x (7) y para y (3)

Ejemplo:
7.3

Esto debido a que en laravel y php tienen diferentes convenciones a seguir

> #### Crear imagen (utilizar la terminación dev para identificar que es imagen de desarrollo (local) y sin dev para (testing-production))

Navegar a la carpeta que se desea crear la imagen

> ## Build docker

Crear la imagen docker, validando que todo este en buen funcionamiento

Ejemplo (dev)
`docker build -t developertoyosa/laravel:x.yy-phpx.y-dev .`

Ejemplo (test-prod)
`docker build -t developertoyosa/laravel:x.yy-phpx.y .`


> #### Crear un docker de prueba

Ejemplo (dev)
`docker run --rm -it --name docker-build-test -v $(pwd):/app developertoyosa/laravel:x.yy-phpx.y-dev`

Ejemplo (test-prod)
`docker run -it --rm --name docker-build-test -v $(pwd):/app developertoyosa/laravel:x.yy-phpx.y`


> #### Publicar docker 

`docker login`

Ejemplo (dev)
`docker push developertoyosa/laravel:x.yy-phpx.y-dev`

Ejemplo (test-prod)
`docker push developertoyosa/laravel:x.yy-phpx.y`

> ## Verificación de versiones
`php -v`
