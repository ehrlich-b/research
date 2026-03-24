#!/bin/bash
# Sync public research repo from private sources.
# Sources:
#   ~/repos/blog/landing/papers/     -> papers/
#   ~/scratch/get-physics-done/derivations/ -> derivations/
#   ~/scratch/get-physics-done/code/       -> verification/
#   ~/repos/blog/research/self-modeling-constants/ -> experiments/
#
# Run from the research repo root.

set -euo pipefail

BLOG="$HOME/repos/blog"
GPD="$HOME/scratch/get-physics-done"
HERE="$(cd "$(dirname "$0")" && pwd)"

cd "$HERE"

echo "Syncing papers..."
for dir in qm-from-self-modeling spacetime-from-self-modeling sm-from-self-modeling; do
    rsync -a --delete "$BLOG/landing/papers/$dir/" "papers/$dir/" \
        --exclude='*.aux' --exclude='*.log' --exclude='*.out' --exclude='*.xdv' --exclude='*.bbl' --exclude='*.blg' \
        --exclude='*.sty' --exclude='*.md' --exclude='.claude'
done
for f in experiential-measure-2026 born-fisher-2026 theorem-a-proof theorem-a-lemmas lipschitz-stability spacetime-from-self-modeling-2026 sm-from-self-modeling-2026; do
    cp "$BLOG/landing/papers/${f}.tex" papers/ 2>/dev/null || true
    cp "$BLOG/landing/papers/${f}.pdf" papers/ 2>/dev/null || true
done

echo "Syncing derivations..."
rsync -a --delete "$GPD/derivations/" derivations/ --include='*.md' --exclude='*'

echo "Syncing verification code..."
rsync -a --delete "$GPD/code/" verification/ --include='*.py' --exclude='*'

echo "Syncing experiment code..."
rsync -a "$BLOG/research/self-modeling-constants/code/" experiments/code/ \
    --include='*.py' --include='requirements.txt' --exclude='*'
cp "$BLOG/research/self-modeling-constants/EPISTEMIC_POKER.md" experiments/ 2>/dev/null || true

echo "Done. Review changes with: git diff --stat"
