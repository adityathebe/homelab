helm install nfs-subdir-kube-data-provisioner nfs-subdir-external-provisioner/nfs-subdir-external-provisioner \
  --set nfs.server=nas.home.adityathebe.com \
  --set nfs.path=/mnt/mega/kubernetes \
  --set nfs.mountOptions='{nfsvers=4.0,hard}' \
  --set storageClass.name=kubedata \
  --set storageClass.pathPattern='${.PVC.annotations.nfs.io/storage-path}' \
  --set storageClass.accessModes=ReadWriteMany \
  --set storageClass.archiveOnDelete=false \
  --set storageClass.reclaimPolicy=Retain \
  --namespace nfs-subdir --create-namespace

helm install nfs-subdir-media-provisioner nfs-subdir-external-provisioner/nfs-subdir-external-provisioner \
  --set nfs.server=nas.home.adityathebe.com \
  --set nfs.path=/mnt/mega/media \
  --set nfs.mountOptions='{nfsvers=4.0,hard}' \
  --set storageClass.name=media-nfs \
  --set storageClass.pathPattern='${.PVC.annotations.nfs.io/storage-path}' \
  --set storageClass.accessModes=ReadWriteMany \
  --set storageClass.archiveOnDelete=false \
  --set storageClass.reclaimPolicy=Retain \
  --namespace nfs-subdir --create-namespace

helm install nfs-subdir-photos-provisioner nfs-subdir-external-provisioner/nfs-subdir-external-provisioner \
  --set nfs.server=nas.home.adityathebe.com \
  --set nfs.path=/mnt/mega/photos \
  --set nfs.mountOptions='{nfsvers=4.0,hard}' \
  --set storageClass.name=photos-nfs \
  --set storageClass.pathPattern='${.PVC.annotations.nfs.io/storage-path}' \
  --set storageClass.accessModes=ReadWriteMany \
  --set storageClass.archiveOnDelete=false \
  --set storageClass.reclaimPolicy=Retain \
  --namespace nfs-subdir --create-namespace