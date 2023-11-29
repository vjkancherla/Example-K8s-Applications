
env_name=$1

if [ -z "$env_name" ]; then
  env_name="non-prod"
fi

for dir in $(ls -d */ | cut -f1 -d '/')
do
    echo ""
    echo "Entering Directory: ${dir}"
    cd ${dir}
    
    echo ""
    echo "Executing 'terraform init'..."
    terraform init 

    echo ""
    echo "Executing 'terraform plan -var-file=envs/${env_name}.tfvars -out=${dir}-tfplan'..."
    terraform plan -var-file=envs/${env_name}.tfvars -out=${dir}-tfplan

    echo ""
    echo "Executing 'terraform apply -input=false ${dir}-tfplan'..."
    terraform apply -input=false ${dir}-tfplan 

    rm ${dir}-tfplan

    echo ""
    echo "Exiting Directory: ${dir}"
    cd ..
done 

