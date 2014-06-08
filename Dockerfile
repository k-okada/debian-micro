# Start from a Debian Jessie base image
FROM debian:jessie

# Install the required packages for the development enviromnent
RUN apt-get update && apt-get -y install busybox-static adduser bzip2 xz-utils insserv module-init-tools sudo debootstrap cpio syslinux xorriso bash vim squashfs-tools

# Add files into the development image
ADD hooks /root/hooks
ADD buildboot /root/buildboot/
ADD includes.binary /root/includes.binary/
ADD includes.chroot /root/includes.chroot/
ADD package-lists /root/package-lists/

# Add version information
ADD VERSION /root/includes.binary/version
ADD VERSION /root/includes.chroot/etc/version

# Run the wrapper
CMD ["/root/buildboot/wrapper.sh"]

