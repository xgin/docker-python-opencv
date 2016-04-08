# docker-python-opencv

A Docker Image with OpenCV (built from source) and FFMPEG (built from source) based on the official python image

Forked from https://github.com/ampervue/docker-python27-opencv

## Known issues

### libdc1394 error: Failed to initialize libdc1394

Mount `-v /dev/null:/dev/raw1394` or run in container `ln /dev/null /dev/raw1394`
