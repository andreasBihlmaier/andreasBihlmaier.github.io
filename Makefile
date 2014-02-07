IMAGE_SMALL_SIZE=400x500
IMAGE_MEDIUM_SIZE=500x600
IMAGE_LARGE_SIZE=1600x1200
IMAGES=$(wildcard images/*.jpg images/*.png)
SMALL_IMAGES=$(subst images,images/small,$(IMAGES))
MEDIUM_IMAGES=$(subst images,images/medium,$(IMAGES))
LARGE_IMAGES=$(subst images,images/large,$(IMAGES))


.PHONY: all
all: images


images: $(SMALL_IMAGES) $(MEDIUM_IMAGES) $(LARGE_IMAGES)

images/small/%.jpg: images/%.jpg
	convert $< -resize $(IMAGE_SMALL_SIZE) $@
images/medium/%.jpg: images/%.jpg
	convert $< -resize $(IMAGE_MEDIUM_SIZE) $@
images/large/%.jpg: images/%.jpg
	convert $< -resize $(IMAGE_LARGE_SIZE) $@
# C&P: s/\.jpg/.png/g
images/small/%.png: images/%.png
	convert $< -resize $(IMAGE_SMALL_SIZE) $@
images/medium/%.png: images/%.png
	convert $< -resize $(IMAGE_MEDIUM_SIZE) $@
images/large/%.png: images/%.png
	convert $< -resize $(IMAGE_LARGE_SIZE) $@
