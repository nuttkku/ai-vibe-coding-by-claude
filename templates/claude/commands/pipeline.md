Run the project pipeline exactly as specified in docs/pipeline.md and report back in Thai.

Arguments (optional): $ARGUMENTS   (use "--no-deploy" to stop before the Deploy stage)

1. Read docs/pipeline.md and confirm scripts/pipeline.sh still matches every stage and rule. If it does not, stop and list the differences instead of running.
2. Run `bash scripts/pipeline.sh $ARGUMENTS`.
3. If a stage fails, stop. Show the stage name and the key error lines, explain the likely cause, and propose a fix. Do NOT skip stages, disable tests, or lower security thresholds to make it pass.
4. End with a table: stage, result (pass/fail), duration.
