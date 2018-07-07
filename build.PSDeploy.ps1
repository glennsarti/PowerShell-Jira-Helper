# Generic module deployment.
# This stuff should be moved to psake for a cleaner deployment view

# ASSUMPTIONS:

# folder structure of:
# - RepoFolder
#   - This PSDeploy file
#   - ModuleName
#     - ModuleName.psd1

# Nuget key in $ENV:NugetApiKey

# Set-BuildEnvironment from BuildHelpers module has populated ENV:BHProjectName

# find a folder that has psd1 of same name...

if ($ENV:BHProjectName -and $ENV:BHProjectName.Count -eq 1) {
  Deploy JiraHelper-Local {
    By Filesystem {
      FromSource $ENV:BHProjectName
      To output\$ENV:BHProjectName
    }
  }
} # else {
#   Deploy Module {
#     By Filesystem  {
#       FromSource output\$ENV:BHProjectName
#       To PSGallery
#       WithOptions @{
#         ApiKey = $ENV:NugetApiKey
#       }
#     }
#   }
# }
