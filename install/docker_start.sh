docker run -d \
  --name devtest \
  --mount source=myvol2,target=/app \
  nginx:latest