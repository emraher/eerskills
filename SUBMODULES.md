# Submodule Management Guide

This repository uses git submodules to integrate external skill collections. This allows you to easily pull updates from upstream repositories.

## Current Submodules

| Submodule | Path | Repository | Purpose |
|-----------|------|------------|---------|
| humanizer | `external/humanizer/` | [blader/humanizer](https://github.com/blader/humanizer) | Wikipedia's 24-pattern AI writing checklist |
| cc-polymath | `external/cc-polymath/` | [rand/cc-polymath](https://github.com/rand/cc-polymath) | Additional anti-slop patterns |
| posit-skills | `external/posit-skills/` | [posit-dev/skills](https://github.com/posit-dev/skills) | Posit's official R/Quarto skills |

## Quick Commands

### Update All Submodules

Pull the latest changes from all upstream repositories:

```bash
git submodule update --remote --merge
```

### Update Specific Submodule

```bash
# Update just humanizer
cd external/humanizer
git pull origin main
cd ../..

# Update just cc-polymath
cd external/cc-polymath
git pull origin main
cd ../..

# Update just posit-skills
cd external/posit-skills
git pull origin main
cd ../..
```

### Check Submodule Status

```bash
# Show current commit for each submodule
git submodule status

# Show if submodules have updates available
git submodule foreach 'git fetch && git status'
```

### Clone Repository with Submodules

When cloning this repository for the first time:

```bash
# Option 1: Clone and init submodules in one command
git clone --recursive https://github.com/emraher/eer-skills.git

# Option 2: Clone first, then init submodules
git clone https://github.com/emraher/eer-skills.git
cd eer-skills
git submodule update --init --recursive
```

## Complete Update Workflow

To update your entire skill collection (EER skills + all external skills):

```bash
# 1. Update main EER skills repository
git pull

# 2. Update all submodules
git submodule update --remote --merge

# 3. Commit the submodule updates (if any)
git status
git add .gitmodules external/humanizer external/cc-polymath external/posit-skills
git commit -m "Update submodules to latest versions"
```

## Understanding Submodule Commits

Submodules are tracked by commit hash. When you see changes like:

```
-Subproject commit abc123
+Subproject commit def456
```

This means the submodule has been updated to point to a newer commit.

## Working with Submodules

### Make Changes in a Submodule

If you want to contribute to a submodule:

```bash
# 1. Navigate to the submodule
cd external/humanizer

# 2. Create a branch
git checkout -b my-feature

# 3. Make changes and commit
git add .
git commit -m "Add new feature"

# 4. Push to your fork (if you have one)
git push origin my-feature

# 5. Submit a PR to the upstream repository
```

### Temporarily Use a Fork

If you have a fork of a submodule:

```bash
# Navigate to submodule
cd external/humanizer

# Add your fork as a remote
git remote add fork https://github.com/yourusername/humanizer.git

# Fetch and checkout your fork's branch
git fetch fork
git checkout -b my-changes fork/my-branch

# Return to main repo and commit the change
cd ../..
git add external/humanizer
git commit -m "Use fork of humanizer with custom changes"
```

## Removing a Submodule

If you want to remove a submodule:

```bash
# 1. Deinitialize the submodule
git submodule deinit external/cc-polymath

# 2. Remove from git
git rm external/cc-polymath

# 3. Remove from .git/modules
rm -rf .git/modules/external/cc-polymath

# 4. Commit the removal
git commit -m "Remove cc-polymath submodule"
```

## Adding a New Submodule

To add another external skill repository:

```bash
# Add as a submodule
git submodule add https://github.com/username/repo.git external/repo-name

# Initialize and update
git submodule update --init --recursive

# Commit the addition
git add .gitmodules external/repo-name
git commit -m "Add repo-name as submodule"
```

## Troubleshooting

### Submodule is empty after clone

```bash
git submodule update --init --recursive
```

### Submodule has uncommitted changes

```bash
cd external/humanizer
git status
# Either commit the changes or reset
git reset --hard HEAD
cd ../..
```

### Submodule is detached HEAD

This is normal! Submodules track specific commits, not branches.

To update to the latest:
```bash
cd external/humanizer
git checkout main
git pull
cd ../..
git add external/humanizer
git commit -m "Update humanizer to latest main"
```

### Conflicts when updating submodules

```bash
cd external/humanizer
git status
# Resolve conflicts manually
git add .
git commit -m "Resolve conflicts"
cd ../..
git add external/humanizer
git commit -m "Update humanizer after resolving conflicts"
```

## Best Practices

1. **Regular Updates**: Update submodules weekly to stay current
   ```bash
   git submodule update --remote --merge
   ```

2. **Document Dependencies**: Keep this file updated when adding/removing submodules

3. **Version Pin**: Submodules are pinned to specific commits for stability
   - This is intentional and good practice
   - Update explicitly when you want newer versions

4. **Test After Updates**: After updating submodules, test that everything still works
   ```bash
   # Run your detection scripts
   python toolkit/scripts/detect_slop.py test.md
   ```

5. **Commit Submodule Updates**: Don't forget to commit when submodules change
   ```bash
   git add external/
   git commit -m "Update submodules"
   ```

## External Skill Usage

### Using Posit Skills Alongside EER Skills

The Posit skills are in `external/posit-skills/`. To use them:

```bash
# Symlink to Claude Code skills directory
ln -s $(pwd)/external/posit-skills ~/.claude/skills/posit

# Or copy specific skills you want
cp -r external/posit-skills/quarto ~/.claude/skills/posit-quarto
```

See [INTEGRATION.md](INTEGRATION.md) for detailed integration guidance.

### Using CC-Polymath Skills

The cc-polymath anti-slop patterns are in `external/cc-polymath/skills/anti-slop/`:

```bash
# Explore available skills
ls external/cc-polymath/skills/anti-slop/

# Reference patterns from their documentation
cat external/cc-polymath/skills/anti-slop/README.md
```

## Resources

- [Git Submodules Documentation](https://git-scm.com/book/en/v2/Git-Tools-Submodules)
- [Pro Git: Submodules](https://git-scm.com/book/en/v2/Git-Tools-Submodules)
- [GitHub: Working with Submodules](https://github.blog/2016-02-01-working-with-submodules/)
