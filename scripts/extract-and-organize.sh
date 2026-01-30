#!/usr/bin/env bash
set -e

# Ensure we're using bash 4+ for associative arrays
if ((BASH_VERSINFO[0] < 4)); then
    echo "This script requires bash 4.0 or higher."
    echo "On macOS, install with: brew install bash"
    echo "Current bash version: $BASH_VERSION"
    # Fall back to simpler approach
fi

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}Skills & Agents Catalog - Full Extraction${NC}"
echo -e "${BLUE}========================================${NC}"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"
SOURCES_DIR="$ROOT_DIR/sources"
CATALOG_DIR="$ROOT_DIR/catalog"

# Create directory structure
echo -e "\n${YELLOW}Creating directory structure...${NC}"

for cat in research investments competitor-analysis marketing content development automation data-analysis security collaboration education; do
    mkdir -p "$CATALOG_DIR/$cat/agents"
    mkdir -p "$CATALOG_DIR/$cat/skills"
    mkdir -p "$CATALOG_DIR/$cat/plugins"
    mkdir -p "$CATALOG_DIR/$cat/tools"
done

mkdir -p "$SOURCES_DIR"

# Clone or update all source repositories
echo -e "\n${YELLOW}Cloning/updating source repositories...${NC}"

clone_repo() {
    local name="$1"
    local repo="$2"
    local branch="${3:-main}"
    local target="$SOURCES_DIR/$name"

    if [ -d "$target" ]; then
        echo -e "${BLUE}Updating $name...${NC}"
        cd "$target"
        git pull --quiet 2>/dev/null || true
        cd "$ROOT_DIR"
    else
        echo -e "${GREEN}Cloning $name...${NC}"
        git clone --quiet --depth 1 -b "$branch" "https://github.com/$repo.git" "$target" 2>/dev/null || {
            echo -e "${YELLOW}Trying without branch for $name...${NC}"
            git clone --quiet --depth 1 "https://github.com/$repo.git" "$target" 2>/dev/null || true
        }
    fi
}

clone_repo "awesome-claude-code-subagents" "nivkazdan/awesome-claude-code-subagents" "main"
clone_repo "claude-code-plugins-plus-skills" "nivkazdan/claude-code-plugins-plus-skills" "main"
clone_repo "awesome-claude-skills" "nivkazdan/awesome-claude-skills" "main"
clone_repo "superpowers" "nivkazdan/superpowers" "main"
clone_repo "claude-flow" "nivkazdan/claude-flow" "main"
clone_repo "claude-code-heavy" "nivkazdan/claude-code-heavy" "main"
clone_repo "dev-browser" "nivkazdan/dev-browser" "main"
clone_repo "Skill_Seekers" "nivkazdan/Skill_Seekers" "development"

# Function to determine categories based on filename
get_categories_for_item() {
    local filename="$1"
    local source_category="$2"
    local categories=""
    local lower_name
    lower_name=$(echo "$filename" | tr '[:upper:]' '[:lower:]')

    # Research keywords
    if echo "$lower_name" | grep -qE "(research|analyst|analysis|search|explore|investigate|trend|crawl|scrape)"; then
        categories="$categories research"
    fi

    # Investments keywords
    if echo "$lower_name" | grep -qE "(invest|finance|fintech|trading|portfolio|quant|risk|crypto|defi|yield|staking|arbitrage|market|price|wallet|token|blockchain|payment|financial|tax|roi|excel)"; then
        categories="$categories investments"
    fi

    # Competitor analysis keywords
    if echo "$lower_name" | grep -qE "(competitive|competitor|market-research|benchmark|intelligence|monitor|comparison)"; then
        categories="$categories competitor-analysis"
    fi

    # Marketing keywords
    if echo "$lower_name" | grep -qE "(marketing|content-market|seo|brand|campaign|social|ads|growth|lead|email-market)"; then
        categories="$categories marketing"
    fi

    # Content keywords
    if echo "$lower_name" | grep -qE "(content|writer|writing|documentation|docs|readme|technical-writer|api-document|changelog|release-notes|visual|blog|article)"; then
        categories="$categories content"
    fi

    # Development keywords
    if echo "$lower_name" | grep -qE "(developer|engineer|architect|coder|programming|code|frontend|backend|fullstack|mobile|web|api|database|devops|infrastructure|cloud|kubernetes|docker|terraform|python|javascript|typescript|react|vue|angular|node|java|golang|rust|swift|kotlin|php|ruby|rails|django|laravel|spring|dotnet|electron|flutter|graphql|rest|grpc|websocket|microservices|mcp|compiler|debugger|refactor|build|test|lint)"; then
        categories="$categories development"
    fi

    # Automation keywords
    if echo "$lower_name" | grep -qE "(automation|workflow|orchestrat|pipeline|ci-cd|deploy|script|bot|scheduler|cron|task|n8n|zapier|make|agent|swarm|coordinator|hook|trigger)"; then
        categories="$categories automation"
    fi

    # Data analysis keywords
    if echo "$lower_name" | grep -qE "(data|analytics|ml|ai|machine-learning|deep-learning|neural|nlp|computer-vision|prediction|forecast|model|dataset|preprocessing|feature|visualization|dashboard|report|metrics|statistics)"; then
        categories="$categories data-analysis"
    fi

    # Security keywords
    if echo "$lower_name" | grep -qE "(security|audit|penetration|vulnerability|compliance|encryption|authentication|authorization|oauth|jwt|injection|xss|csrf|scanner|hardening|rbac|iam|gdpr|hipaa|pci|soc2|iso27001|forensics|incident)"; then
        categories="$categories security"
    fi

    # Collaboration keywords
    if echo "$lower_name" | grep -qE "(collaboration|team|project-manager|scrum|agile|sprint|github|git|pr|issue|code-review|slack|communication|coordination|sync|multi-agent)"; then
        categories="$categories collaboration"
    fi

    # Education keywords
    if echo "$lower_name" | grep -qE "(education|tutorial|learning|training|guide|example|onboarding|skill|teaching|explanation|basics|fundamentals|intro)"; then
        categories="$categories education"
    fi

    # If no categories matched, assign based on source category
    if [ -z "$(echo "$categories" | tr -d ' ')" ]; then
        case "$source_category" in
            01-core-development|02-language-specialists|05-frontend-dev|06-backend-dev|15-api-development|core|development)
                categories="development"
                ;;
            03-infrastructure|devops|13-aws-skills|14-gcp-skills)
                categories="development automation"
                ;;
            04-quality-security|03-security-fundamentals|04-security-advanced|security)
                categories="security"
                ;;
            05-data-ai|07-ml-training|08-ml-deployment|11-data-pipelines|12-data-analytics|data|analysis)
                categories="data-analysis"
                ;;
            08-business-product|19-business-automation)
                categories="marketing automation"
                ;;
            09-meta-orchestration|20-enterprise-workflows|orchestration|swarm|consensus)
                categories="automation collaboration"
                ;;
            10-research-analysis)
                categories="research data-analysis"
                ;;
            17-technical-docs|18-visual-content|documentation)
                categories="content education"
                ;;
            github|git)
                categories="collaboration development"
                ;;
            *)
                categories="development"
                ;;
        esac
    fi

    echo "$categories"
}

# Copy item to multiple categories
copy_to_categories() {
    local source_path="$1"
    local item_type="$2"
    local categories="$3"
    local target_name="$4"

    for cat in $categories; do
        local target_dir="$CATALOG_DIR/$cat/$item_type"
        if [ -d "$target_dir" ]; then
            if [ -d "$source_path" ]; then
                local final_target="$target_dir/$target_name"
                if [ ! -d "$final_target" ]; then
                    cp -r "$source_path" "$final_target" 2>/dev/null || true
                fi
            elif [ -f "$source_path" ]; then
                cp "$source_path" "$target_dir/" 2>/dev/null || true
            fi
        fi
    done
}

echo -e "\n${YELLOW}Processing awesome-claude-code-subagents (128 agents)...${NC}"

if [ -d "$SOURCES_DIR/awesome-claude-code-subagents/categories" ]; then
    agent_count=0
    for category_dir in "$SOURCES_DIR/awesome-claude-code-subagents/categories"/*; do
        if [ -d "$category_dir" ]; then
            category_name=$(basename "$category_dir")
            for agent_file in "$category_dir"/*.md; do
                if [ -f "$agent_file" ]; then
                    filename=$(basename "$agent_file")
                    if [ "$filename" != "README.md" ]; then
                        categories=$(get_categories_for_item "$filename" "$category_name")
                        copy_to_categories "$agent_file" "agents" "$categories" ""
                        ((agent_count++)) || true
                    fi
                fi
            done
        fi
    done
    echo -e "${GREEN}  Processed $agent_count agents${NC}"
fi

echo -e "\n${YELLOW}Processing claude-code-plugins-plus-skills plugins...${NC}"

if [ -d "$SOURCES_DIR/claude-code-plugins-plus-skills/plugins" ]; then
    plugin_count=0
    for plugin_category in "$SOURCES_DIR/claude-code-plugins-plus-skills/plugins"/*; do
        if [ -d "$plugin_category" ]; then
            category_name=$(basename "$plugin_category")
            # Skip non-plugin items
            case "$category_name" in
                examples|packages|JEREMY*|README*|install*|*.md|*.sh)
                    continue
                    ;;
            esac

            for plugin_dir in "$plugin_category"/*; do
                if [ -d "$plugin_dir" ]; then
                    plugin_name=$(basename "$plugin_dir")
                    # Skip non-plugin items
                    case "$plugin_name" in
                        *.md|*.sh|*.json|LAUNCH*|TEST*|PLUGINS*|QUICK*)
                            continue
                            ;;
                    esac

                    categories=$(get_categories_for_item "$plugin_name" "$category_name")
                    copy_to_categories "$plugin_dir" "plugins" "$categories" "$plugin_name"
                    ((plugin_count++)) || true
                fi
            done
        fi
    done
    echo -e "${GREEN}  Processed $plugin_count plugins${NC}"
fi

echo -e "\n${YELLOW}Processing claude-code-plugins-plus-skills skills...${NC}"

if [ -d "$SOURCES_DIR/claude-code-plugins-plus-skills/skills" ]; then
    skill_count=0
    for skill_category in "$SOURCES_DIR/claude-code-plugins-plus-skills/skills"/*; do
        if [ -d "$skill_category" ]; then
            category_name=$(basename "$skill_category")
            [ "$category_name" = "README.md" ] && continue

            for skill_dir in "$skill_category"/*; do
                if [ -d "$skill_dir" ]; then
                    skill_name=$(basename "$skill_dir")
                    categories=$(get_categories_for_item "$skill_name" "$category_name")
                    copy_to_categories "$skill_dir" "skills" "$categories" "$skill_name"
                    ((skill_count++)) || true
                fi
            done
        fi
    done
    echo -e "${GREEN}  Processed $skill_count skills${NC}"
fi

echo -e "\n${YELLOW}Processing claude-flow agents...${NC}"

if [ -d "$SOURCES_DIR/claude-flow/.claude/agents" ]; then
    agent_count=0
    find "$SOURCES_DIR/claude-flow/.claude/agents" -name "*.md" -type f | while read -r agent_file; do
        filename=$(basename "$agent_file")
        if [ "$filename" != "README.md" ] && [ "$filename" != "MIGRATION_SUMMARY.md" ]; then
            parent_dir=$(basename "$(dirname "$agent_file")")
            categories=$(get_categories_for_item "$filename" "$parent_dir")

            for cat in $categories; do
                target_dir="$CATALOG_DIR/$cat/agents"
                cp "$agent_file" "$target_dir/cf-$filename" 2>/dev/null || true
            done
        fi
    done
    agent_count=$(find "$SOURCES_DIR/claude-flow/.claude/agents" -name "*.md" -type f ! -name "README.md" ! -name "MIGRATION_SUMMARY.md" 2>/dev/null | wc -l | tr -d ' ')
    echo -e "${GREEN}  Processed $agent_count agents${NC}"
fi

echo -e "\n${YELLOW}Processing superpowers skills...${NC}"

if [ -d "$SOURCES_DIR/superpowers/skills" ]; then
    skill_count=0
    for skill_dir in "$SOURCES_DIR/superpowers/skills"/*; do
        if [ -d "$skill_dir" ]; then
            skill_name=$(basename "$skill_dir")
            categories=$(get_categories_for_item "$skill_name" "superpowers")
            copy_to_categories "$skill_dir" "skills" "$categories" "superpowers-$skill_name"
            ((skill_count++)) || true
        fi
    done
    echo -e "${GREEN}  Processed $skill_count skills${NC}"
fi

echo -e "\n${YELLOW}Processing dev-browser skill...${NC}"

if [ -d "$SOURCES_DIR/dev-browser/skills/dev-browser" ]; then
    for cat in automation development research; do
        target_dir="$CATALOG_DIR/$cat/skills/dev-browser"
        cp -r "$SOURCES_DIR/dev-browser/skills/dev-browser" "$target_dir" 2>/dev/null || true
    done
    echo -e "${GREEN}  Processed 1 skill${NC}"
fi

echo -e "\n${YELLOW}Processing claude-code-heavy tool...${NC}"

if [ -d "$SOURCES_DIR/claude-code-heavy" ]; then
    for cat in research data-analysis automation; do
        target_dir="$CATALOG_DIR/$cat/tools/claude-code-heavy"
        mkdir -p "$target_dir"
        cp "$SOURCES_DIR/claude-code-heavy/"*.sh "$target_dir/" 2>/dev/null || true
        cp "$SOURCES_DIR/claude-code-heavy/"*.md "$target_dir/" 2>/dev/null || true
        [ -d "$SOURCES_DIR/claude-code-heavy/examples" ] && cp -r "$SOURCES_DIR/claude-code-heavy/examples" "$target_dir/" 2>/dev/null || true
    done
    echo -e "${GREEN}  Processed 1 tool${NC}"
fi

echo -e "\n${YELLOW}Processing Skill_Seekers tool...${NC}"

if [ -d "$SOURCES_DIR/Skill_Seekers" ]; then
    for cat in development automation education; do
        target_dir="$CATALOG_DIR/$cat/tools/skill-seekers"
        mkdir -p "$target_dir"
        [ -d "$SOURCES_DIR/Skill_Seekers/src" ] && cp -r "$SOURCES_DIR/Skill_Seekers/src" "$target_dir/" 2>/dev/null || true
        [ -d "$SOURCES_DIR/Skill_Seekers/scripts" ] && cp -r "$SOURCES_DIR/Skill_Seekers/scripts" "$target_dir/" 2>/dev/null || true
        cp "$SOURCES_DIR/Skill_Seekers/"*.md "$target_dir/" 2>/dev/null || true
    done
    echo -e "${GREEN}  Processed 1 tool${NC}"
fi

echo -e "\n${YELLOW}Processing awesome-claude-skills reference...${NC}"

if [ -f "$SOURCES_DIR/awesome-claude-skills/README.md" ]; then
    for cat in education research; do
        cp "$SOURCES_DIR/awesome-claude-skills/README.md" "$CATALOG_DIR/$cat/awesome-claude-skills-reference.md" 2>/dev/null || true
    done
    echo -e "${GREEN}  Processed 1 reference${NC}"
fi

# Generate category index files
echo -e "\n${YELLOW}Generating category index files...${NC}"

for cat in research investments competitor-analysis marketing content development automation data-analysis security collaboration education; do
    cat_dir="$CATALOG_DIR/$cat"
    index_file="$cat_dir/README.md"

    agent_count=$(find "$cat_dir/agents" -name "*.md" 2>/dev/null | wc -l | tr -d ' ')
    skill_count=$(find "$cat_dir/skills" -mindepth 1 -maxdepth 1 -type d 2>/dev/null | wc -l | tr -d ' ')
    plugin_count=$(find "$cat_dir/plugins" -mindepth 1 -maxdepth 1 -type d 2>/dev/null | wc -l | tr -d ' ')
    tool_count=$(find "$cat_dir/tools" -mindepth 1 -maxdepth 1 -type d 2>/dev/null | wc -l | tr -d ' ')

    # Create index file
    cat_title=$(echo "$cat" | sed 's/-/ /g' | sed 's/\b\(.\)/\u\1/g')
    echo "# $cat_title Category" > "$index_file"
    echo "" >> "$index_file"
    echo "## Summary" >> "$index_file"
    echo "- **Agents**: $agent_count" >> "$index_file"
    echo "- **Skills**: $skill_count" >> "$index_file"
    echo "- **Plugins**: $plugin_count" >> "$index_file"
    echo "- **Tools**: $tool_count" >> "$index_file"
    echo "- **Total**: $((agent_count + skill_count + plugin_count + tool_count))" >> "$index_file"
    echo "" >> "$index_file"

    echo "## Agents" >> "$index_file"
    if [ "$agent_count" -gt 0 ]; then
        for f in "$cat_dir/agents/"*.md; do
            [ -f "$f" ] && echo "- $(basename "$f" .md)" >> "$index_file"
        done
    else
        echo "None" >> "$index_file"
    fi
    echo "" >> "$index_file"

    echo "## Skills" >> "$index_file"
    if [ "$skill_count" -gt 0 ]; then
        for d in "$cat_dir/skills/"*/; do
            [ -d "$d" ] && echo "- $(basename "$d")" >> "$index_file"
        done
    else
        echo "None" >> "$index_file"
    fi
    echo "" >> "$index_file"

    echo "## Plugins" >> "$index_file"
    if [ "$plugin_count" -gt 0 ]; then
        for d in "$cat_dir/plugins/"*/; do
            [ -d "$d" ] && echo "- $(basename "$d")" >> "$index_file"
        done
    else
        echo "None" >> "$index_file"
    fi
    echo "" >> "$index_file"

    echo "## Tools" >> "$index_file"
    if [ "$tool_count" -gt 0 ]; then
        for d in "$cat_dir/tools/"*/; do
            [ -d "$d" ] && echo "- $(basename "$d")" >> "$index_file"
        done
    else
        echo "None" >> "$index_file"
    fi
    echo "" >> "$index_file"
    echo "---" >> "$index_file"
    echo "*Auto-generated by skills-agents-catalog*" >> "$index_file"
done

# Generate verification report
echo -e "\n${YELLOW}Generating verification report...${NC}"

VERIFICATION_FILE="$ROOT_DIR/VERIFICATION.md"

cat > "$VERIFICATION_FILE" << 'VERIFICATION_EOF'
# Extraction Verification Report

## Source Repository Totals (Expected)

| Source | Type | Expected Count |
|--------|------|----------------|
| awesome-claude-code-subagents | Agents | 128 |
| claude-code-plugins-plus-skills | Plugins | ~323 |
| claude-code-plugins-plus-skills | Skills | ~520 |
| claude-flow | Agents | ~367 |
| superpowers | Skills | 14 |
| dev-browser | Skills | 1 |
| claude-code-heavy | Tools | 1 |
| Skill_Seekers | Tools | 1 |
| **TOTAL** | | **~1,355** |

## Category Distribution (Extracted)

| Category | Agents | Skills | Plugins | Tools | Total |
|----------|--------|--------|---------|-------|-------|
VERIFICATION_EOF

for cat in research investments competitor-analysis marketing content development automation data-analysis security collaboration education; do
    cat_dir="$CATALOG_DIR/$cat"
    agents=$(find "$cat_dir/agents" -name "*.md" 2>/dev/null | wc -l | tr -d ' ')
    skills=$(find "$cat_dir/skills" -mindepth 1 -maxdepth 1 -type d 2>/dev/null | wc -l | tr -d ' ')
    plugins=$(find "$cat_dir/plugins" -mindepth 1 -maxdepth 1 -type d 2>/dev/null | wc -l | tr -d ' ')
    tools=$(find "$cat_dir/tools" -mindepth 1 -maxdepth 1 -type d 2>/dev/null | wc -l | tr -d ' ')
    total=$((agents + skills + plugins + tools))
    echo "| $cat | $agents | $skills | $plugins | $tools | $total |" >> "$VERIFICATION_FILE"
done

cat >> "$VERIFICATION_FILE" << 'VERIFICATION_EOF'

## Notes

- Items may appear in **multiple categories** based on their use-cases
- Total items across categories may exceed source totals due to multi-category placement
- Each category's README.md contains a detailed listing of all items

## Multi-Category Examples

- Development tools often also appear in Automation
- Security scanners may appear in both Security and Development
- ML/AI items appear in both Data Analysis and Development
- Documentation tools appear in Content and Education

VERIFICATION_EOF

echo "" >> "$VERIFICATION_FILE"
echo "---" >> "$VERIFICATION_FILE"
echo "*Generated: $(date)*" >> "$VERIFICATION_FILE"

echo -e "\n${GREEN}========================================${NC}"
echo -e "${GREEN}Extraction Complete!${NC}"
echo -e "${GREEN}========================================${NC}"
echo -e "\nCatalog location: $CATALOG_DIR"
echo -e "Verification report: $VERIFICATION_FILE"
echo -e "\n${YELLOW}Category totals:${NC}"

for cat in research investments competitor-analysis marketing content development automation data-analysis security collaboration education; do
    cat_dir="$CATALOG_DIR/$cat"
    total=$(find "$cat_dir" \( -name "*.md" -o -type d -mindepth 2 \) 2>/dev/null | wc -l | tr -d ' ')
    printf "  %-20s %s items\n" "$cat:" "$total"
done
