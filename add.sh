#!/bin/sh
##### PLEASE ENTER RELEVANT CONFIG DETAILS #########
source_url='git@bitbucket.org:mmvplproducts/'				#LINK OF REPO ON FROM WHICH RESPOSITORIES WILL BE FETCHED TO USE AS SUB DIRECTORY
target_url='git@bitbucket.org:rahulniyer/' 			#LINK OF REPO ON WHICH THERE WILL BE SUB DIRECTORIES
target_repo='news-corp-india-rahul'								#REPO ON WHICH THERE WILL BE SUB DIRECTORIES
target_branch='develop'
directory=$HOME'/work/projects/'							#DIRECTORY WHERE THE repository will be downloaded and worked upon
plugin_source_branch='master'	 	#WHICH BRANCH TO FETCH from
theme_source_branch='develop'	 	#WHICH BRANCH TO FETCH from
								
plugins=( nc-career nc-ext-syndication nc-post-clusters nc-remote-taxonomy nc-sponsor)
themes=( ncindia-core ncindia-child-vcc )


if [ -d $directory$target_repo ]
	then
		echo "directory already present hence!"
	else
		cd $directory
		echo "directory not present!!! getting required respository"
		git clone $target_url$target_repo
fi

cd $target_repo
git checkout $target_branch

for i in "${plugins[@]}"
do
	cd $directory$target_repo
	if git log | grep git-subtree-dir | tr -d ' ' | cut -d ":" -f2 | sort | uniq | grep $i;	
	then
		echo "Pull request has started"
		git subtree pull --prefix plugins/$i $source_url$i $plugin_source_branch  --squash -m "Synced on {$(date)}"
	else
		git subtree add -P plugins/$i $source_url$i $plugin_source_branch -m "Synced on {$(date)}" 
		echo "New subtree has been added"
	fi    

done


for i in "${themes[@]}"
do
	cd $directory$target_repo
	if git log | grep git-subtree-dir | tr -d ' ' | cut -d ":" -f2 | sort | uniq | grep $i;
	then
		echo "Pull request has started"
		git subtree pull --prefix themes/$i $source_url$i $theme_source_branch  --squash -m "Synced on {$(date)}"
	else
		git subtree add -P themes/$i $source_url$i $theme_source_branch -m "Synced on {$(date)}"    #(adding YYY into XXX)
		echo "New subtree has been added"
	fi
done

echo "git push $target_url$target_repo $target_branch"
git push $target_url$target_repo $target_branch


