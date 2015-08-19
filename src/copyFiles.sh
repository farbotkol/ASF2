# grep -i apexpage permissionsets/ECOPortalBase.permissionset | cut -d'>' -f2 | cut -d'<' -f1 | grep ECO |
# while read eachfile
# do
# #    ls -l pages/$eachfile*
#     cp pages/$eachfile* $GDIR/pages
# done

# grep -i apexclass permissionsets/ECOPortalBase.permissionset | cut -d'>' -f2 | cut -d'<' -f1 | grep ECO |
# while read eachfile
# do
# #    ls -l pages/$eachfile*
#     cp classes/$eachfile* $GDIR/classes
# done

# ls -1 triggers/ECO*.trigger* |
# while read eachfile
# do
#   cp $eachfile $GDIR/triggers
# done

# grep -i "<field>" permissionsets/ECOPortalBase.permissionset | cut -d'>' -f2 | cut -d'<' -f1 | cut -d'.' -f1 | sort | uniq |
# while read eachfile
# do
#    cp objects/$eachfile* $GDIR/objects
# done

# grep -i "<object>" permissionsets/ECOPortalBase.permissionset | cut -d'>' -f2 | cut -d'<' -f1 |
# while read eachfile
# do
# #    ls -l objects/$eachfile*
#     cp objects/$eachfile* $GDIR/objects
# done

# grep -i "<application>" permissionsets/ECOPortalBase.permissionset | cut -d'>' -f2 | cut -d'<' -f1 |
# while read eachfile
# do
# #    ls -l applications/$eachfile*
#     cp applications/$eachfile* $GDIR/applications
# done

grep -i "<tab>" permissionsets/ECOPortalBase.permissionset | cut -d'>' -f2 | cut -d'<' -f1 |
while read eachfile
do
#    ls -l tabs/$eachfile*
    cp tabs/$eachfile* $GDIR/tabs
done
