##### PLEASE ENTER RELEVANT CONFIG DETAILS #########
repo='news-corp-india-rahul'								#REPO ON WHICH THERE WILL BE SUB DIRECTORIES
remote_repo_link='git@bitbucket.org:rahulniyer/' 			#LINK OF REPO ON WHICH THERE WILL BE SUB DIRECTORIES
target_url='git@bitbucket.org:mmvplproducts/'				#LINK OF REPO ON FROM WHICH RESPOSITORIES WILL BE FETCHED TO USE AS SUB DIRECTORY


directory=$HOME'/work/projects/'							#DIRECTORY WHERE THE repository will be downloaded and worked upon
branch='master'												#WHICH BRANCH TO FETCH from
plugins=( nc-career nc-ext-syndication nc-post-clusters nc-remote-taxonomy nc-sponsor)
themes=( ncindia-child-vcc ncindia-core )

for i in "${plugins[@]}"
do
	if [ -d $directory$repo ]
	then
		echo "directory already present hence!"
	else
		cd $directory
		echo "directory not present!!! getting required respository"
		git clone $remote_repo_link$repo
	fi

	cd $directory$repo
	if git log | grep git-subtree-dir | tr -d ' ' | cut -d ":" -f2 | sort | uniq | grep $i;	
	then
		echo "Pull request has started"
		git subtree pull --prefix plugins/$i $target_url$i $branch  --squash -m "Synced on {$(date)}"
	else
		git subtree add -P plugins/$i $target_url$i $branch 
		echo "New subtree has been added"
	fi    

done

for i in "${themes[@]}"
do
	if [ -d $directory$repo ]
	then
		echo "directory already present hence!"
	else
		cd $directory
		echo "directory not present!!! getting required respository"
		git clone $remote_repo_link$repo
	fi

	cd $directory$repo
	out=$(git log | grep git-subtree-dir | tr -d ' ' | cut -d ":" -f2 | sort | uniq | grep $i)
	if git log | grep git-subtree-dir | tr -d ' ' | cut -d ":" -f2 | sort | uniq | grep $i;
	then
		echo "Pull request has started"
		git subtree pull --prefix themes/$i $target_url$i $branch  --squash -m "Synced on {$(date)}"
	else
		git subtree add -P themes/$i $target_url$i $branch     #(adding YYY into XXX)
		echo "New subtree has been added"
	fi
done

echo "git push $remote_repo_link$repo $branch"
git push $remote_repo_link$repo $branch


