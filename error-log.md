Major problem setting up react-router with pnpm workspaces:
    - Tried to define workspace within root package.json => workspace is not visible to pnpm
        solution:
            packages:
                - 'apps/*' -> this wasn't enough = error
                - 'libs/*'
                - 'apps/*/*' -> this was originally not there = error
            - set up react normally, then move react dependencies to root package.json.
            - pnpm install
            pnpm --filter web dev -> works
    Next step: setup nx monorepo 

