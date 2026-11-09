IMAGE_ROOTFS_ALIGNMENT = "4096"

XZ_DICTIONARY_SIZE = "64"
XZ_THREADS = "5"
XZ_MEMLIMIT= "6500MiB"
XZ_COMPRESSION_LEVEL = "--verbose --no-adjust --arm64 --lzma2=mode=normal,dict=${XZ_DICTIONARY_SIZE}MiB,lc=1,lp=2,pb=2,mf=bt4,nice=192,depth=1024"
EXTRA_IMAGECMD:ext4 =+ " -b 4096 -N 40960 -E stride=1024,stripe-width=1024,nodiscard -O sparse_super2,^huge_file,dir_index -m 0 -J size=8 "

IMAGE_TYPEDEP:wic = "ext4"
IMAGE_TYPEDEP:wic.xz = "wic"
IMAGE_TYPEDEP:img = "wic"

IMAGE_FSTYPES = "wic wic.xz img"

#IMAGE_TYPES_MASKED = "img"

EXCLUDE_FROM_WORLD = "1"

#inherit image-prelink

IMAGE_CMD:img () {
    ln -f "${IMGDEPLOYDIR}/${IMAGE_NAME}.wic" "${IMGDEPLOYDIR}/${IMAGE_NAME}.img"
}

do_image_wic[depends] += "virtual/bootloader:do_deploy"
