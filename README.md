# monorepo-tools

Tools for syncing a monorepo into multiple read-only subrepos.

## Why monorepo?

Continuous Delivery works best when process and configuration management is simple.

Consider the following scenario:

As part of story #123, Joan needs to add a `date` field to the `graphql-api` and `react-app`
components. Phil is working on the same files for #128, where he needs to rename `zip-code`
to `post-code`.

They both create a branch in each repo. When their changes are made, they each make 
two pull requests. We have 4 branches and 4 PRs. That's a lot to manage!

The build for `react-app#123` has to wait for the build of `graphql-api#123` before
it can be integration-tested. The integration test setup for running `graphql-api`
is complicated, and involves downloading docker images and managing containers.

Build feedback is slow. Approving the branches is cumbersome because they are not
viewable as a single change.
