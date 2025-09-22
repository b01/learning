# Build A Command

Build a command as a string, then run that string as a command:

```shell
run_cmd="avr"
# Global options
run_cmd="${run_cmd} -branch ""${PARAM_MAIN_TRUNK_BRANCH}"""
run_cmd="${run_cmd} -cicd ""${CICD_PLATFORM}"""
run_cmd="${run_cmd} -wd ""${PARAM_WORKING_DIRECTORY}"""

if [ -n "${semver}" ]; then
    run_cmd="${run_cmd} -semver \"${semver}\""
fi

echo "PARAM_ENABLE_TAG_V_PREFIX=${PARAM_ENABLE_TAG_V_PREFIX}"
if [ "${PARAM_ENABLE_TAG_V_PREFIX}" = "true" ] || [ "${PARAM_ENABLE_TAG_V_PREFIX}" = "1" ]; then
    run_cmd="${run_cmd} -enable-tag-v-prefix"
fi

# sub command
run_cmd="${run_cmd} workflow-selector"
# arguments
run_cmd="${run_cmd} ""${PARAM_CHANGELOG_FILE}"""
run_cmd="${run_cmd} ""${GIT_SHA}"""

sh -c "${run_cmd}"
``` 