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

Error setting up nx:
    npx dotnet is not enough, I need system level dotnet command (CONFIRM?) -> Confirm
    Node 25 → child_process spawnSync() on macOS sometimes fails to resolve binaries in PATH correctly (observed in     Nx, Angular CLI, PNPM).

        brew install node@22
    Switch:
        brew link --overwrite node@22
    Verify:
        node -v   # should be v22.x.x
    Now reset Nx cache:
        npx nx reset
    Test:
        npx nx show projects --verbose
    This solves the problem for 99% of users.

Learnt: check path if command is found. Check the shell you use, vscode might be different to system shell, read about service (node) breaking bugs online

1️⃣ Check if the binary exists
which dotnet → confirms a real binary is installed.
dotnet --version → confirms it runs manually.
This rules out “binary is not installed” issues.
2️⃣ Check environment PATH
echo $PATH or npx node -p "process.env.PATH" → ensures the shell sees the binary.
On macOS, remember login shell vs non-login shell: VSCode terminals might load different config files (.zprofile vs .zshrc).
3️⃣ Check where Nx / Node sees PATH
Nx spawns isolated plugin worker processes (spawnSync), which might not inherit your interactive PATH.
Test inside Node:
npx node -e "console.log(process.env.PATH)"
Compare it with your interactive terminal PATH.
If the PATH differs → potential environment inheritance problem.
4️⃣ Check the shell / runtime differences
VSCode integrated terminal vs system shell
Interactive shell vs non-interactive shell
Login shell vs non-login shell
Remember that GUI apps on macOS (like VSCode) don’t always inherit .zprofile or .bash_profile.
5️⃣ Test the command in isolation
Try spawnSync yourself:
const { spawnSync } = require('child_process');
console.log(spawnSync('dotnet', ['--version']));
If this fails → Node process PATH doesn’t see the binary.
If it works → problem is inside Nx plugin code.
6️⃣ Check for tooling / version-specific bugs
Search for Node, Nx, and spawnSync ENOENT bugs.
Node 25 on macOS is known to have child_process binary resolution issues.
Cross-check Node LTS versions (20/22) → see if the problem reproduces.
7️⃣ Check Nx plugin or workspace config
Remove or disable the plugin if unnecessary
Confirm .csproj or .sln files exist if the plugin is needed
✅ Key takeaways / heuristics
ENOENT from spawnSync almost always means binary not found in the PATH of that process, not necessarily that it’s missing on the system.
Always check interactive shell vs process environment.
Node version can break child_process resolution — always consider downgrading to LTS if you see weird binary resolution bugs.
GUI apps on macOS (VSCode, Finder-launched apps) may inherit a different environment than your terminal.

validating /Users/andorgunczer/WORK/PERSONAL/finance-gamify/infra/docker/docker-compose.yaml: services.pgadmin.environment must be a mapping -> syntax error missing tab in docker-compose.yaml