## developing image
### build docker image
```bash
docker build \
  --build-arg HOST_USER=$(whoami) \
  --build-arg HOST_UID=$(id -u) \
  --build-arg HOST_GID=$(id -g) \
  -f compose_m_dev.dockerfile \
  -t wiennan/compose_m:dev_20251006_m1 .
```
### start developing container
```bash
docker run -itd --name=compose_m_dev --user $(id -u):$(id -g) \
	--mount type=bind,source=/home/wiennan/.ssh,target=/home/wiennan/.ssh \
	--mount type=bind,source=/home/wiennan/workspace,target=/home/wiennan/workspace \
	--network=host \
	--runtime=nvidia -e NVIDIA_VISIBLE_DEVICES=all -e NVIDIA_DRIVER_CAPABILITIES=all \
	wiennan/compose_m:dev_20251006_m1 \
	/bin/bash
```
## ffmpeg
inside developing container
### configure options
```bash
./configure --enable-gpl \
    --enable-version3 \
    --enable-nonfree \
    --enable-shared \
    --disable-static \
	--disable-ffplay \
	--prefix=$HOME/workspace/shared_libs/ffmpeg8.0 \
    --extra-cflags=-I/usr/local/cuda/include \
    --extra-ldflags=-L/usr/local/cuda/lib64 \
    --enable-cuda-nvcc \
    --enable-libnpp \
    --enable-gray \
    --disable-htmlpages \
    --disable-podpages \
    --disable-txtpages \
    --enable-libaom \
    --enable-libcodec2 \
    --enable-libdav1d \
    --enable-libgsm \
    --enable-libvpl \
    --enable-libmp3lame \
    --enable-libopenjpeg \
    --enable-libopus \
    --enable-librsvg \
    --enable-libshine \
    --enable-libsnappy \
    --enable-libspeex \
    --enable-libtheora \
    --enable-libtwolame \
    --enable-libvorbis \
    --enable-libvpx \
    --enable-libwebp \
    --enable-libx264 \
    --enable-libx265 \
    --enable-libxvid \
    --enable-libzvbi \
    --enable-opencl \
    --enable-openssl \
    --enable-librtmp \
    --enable-libxml2 \
    --enable-cuda-nvcc \
    --enable-libdrm \
    --enable-frei0r \
    --enable-libass \
    --enable-opengl
```