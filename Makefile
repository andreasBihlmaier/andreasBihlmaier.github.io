IMAGE_SMALL_SIZE=400x500
IMAGE_MEDIUM_SIZE=500x600
IMAGES=$(wildcard images/*.jpg images/*.png)
SMALL_IMAGES=$(subst images,images/small,$(IMAGES))
MEDIUM_IMAGES=$(subst images,images/medium,$(IMAGES))


.PHONY: all
all: images


images: $(SMALL_IMAGES) $(MEDIUM_IMAGES)

images/small/%.jpg: images/%.jpg
	convert $< -resize $(IMAGE_SMALL_SIZE) $@
images/small/%.png: images/%.png
	convert $< -resize $(IMAGE_SMALL_SIZE) $@
images/medium/%.jpg: images/%.jpg
	convert $< -resize $(IMAGE_MEDIUM_SIZE) $@
images/medium/%.png: images/%.png
	convert $< -resize $(IMAGE_MEDIUM_SIZE) $@
