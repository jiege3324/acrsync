src_acr=mbbservicepreprod
des_acr=mbbserviceprod

az acr helm repo add -n $src_acr
az acr helm repo add -n $des_acr
helmcharts=`az acr helm list -n $src_acr --query 'keys(@)' -o tsv`
echo $helmcharts
for chart in $helmcharts;
do
  cmd=`echo "az acr helm list -n $src_acr --query '\"$chart\"[].version' -o tsv"`
  # echo $cmd
  versions=`eval $cmd`
  # echo $versions
  for version in $versions;
  do
    helm fetch $src_acr/$chart --version $version
    az acr helm push --name $des_acr $chart-$version.tgz
  done
done

