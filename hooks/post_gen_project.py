#!/usr/bin/env python3
"""Post-generation hook to clean up conditional files."""

import os
import shutil

def remove_file_if_exists(filepath):
    """Remove file if it exists."""
    if os.path.exists(filepath):
        os.remove(filepath)
        print(f"Removed {filepath}")

def remove_dir_if_exists(dirpath):
    """Remove directory if it exists."""
    if os.path.exists(dirpath):
        shutil.rmtree(dirpath)
        print(f"Removed {dirpath}")

def show_summary_and_confirm():
    """Show project summary and ask for confirmation."""
    print("\n" + "="*60)
    print("PROJECT GENERATION SUMMARY")
    print("="*60)
    print(f"Project Name: {{ cookiecutter.project_name }}")
    print(f"Package Name: {{ cookiecutter.package_name }}")
    print(f"Author: {{ cookiecutter.author_name }} <{{ cookiecutter.author_email }}>")
    print(f"Description: {{ cookiecutter.project_description }}")
    print(f"Python Version: {{ cookiecutter.python_version }}")
    print(f"Include Packaging: {{ cookiecutter.include_packaging }}")
    print(f"Include MkDocs: {{ cookiecutter.include_mkdocs }}")
    print(f"License: {{ cookiecutter.license }}")
    print("="*60)
    
    while True:
        response = input("\nDoes this look correct? (y/n/s) [y=yes, n=delete and exit, s=show files]: ").lower().strip()
        
        if response in ['y', 'yes', '']:
            print("✅ Project generated successfully!")
            return True
        elif response in ['n', 'no']:
            print("❌ Deleting generated project...")
            import shutil
            project_dir = os.getcwd()
            parent_dir = os.path.dirname(project_dir)
            os.chdir(parent_dir)
            shutil.rmtree(project_dir)
            print(f"Deleted {os.path.basename(project_dir)}")
            print("💡 Run cookiecutter again with corrected values")
            return False
        elif response in ['s', 'show']:
            print("\n📁 Generated files:")
            for root, dirs, files in os.walk("."):
                # Skip hidden directories and __pycache__
                dirs[:] = [d for d in dirs if not d.startswith('.') and d != '__pycache__']
                level = root.replace(".", "").count(os.sep)
                indent = " " * 2 * level
                print(f"{indent}{os.path.basename(root)}/")
                subindent = " " * 2 * (level + 1)
                for file in files:
                    if not file.startswith('.'):
                        print(f"{subindent}{file}")
        else:
            print("Please enter 'y' (yes), 'n' (no), or 's' (show files)")

def setup_gitignore():
    """Set up .gitignore based on selected profile."""
    profile = "{{ cookiecutter.gitignore_profile }}"
    template_path = f"gitignore_templates/{profile}.gitignore"
    
    if os.path.exists(template_path):
        # Copy the selected template to .gitignore
        with open(template_path, 'r') as template_file:
            content = template_file.read()
        
        with open('.gitignore', 'w') as gitignore_file:
            gitignore_file.write(content)
        
        print(f"✅ Applied {profile} .gitignore profile")
    else:
        print(f"⚠️  Template {template_path} not found, keeping default .gitignore")
    
    # Clean up template directory
    remove_dir_if_exists("gitignore_templates")

def create_virtual_environment():
    """Create virtual environment if requested."""
    if "{{ cookiecutter.create_venv }}" == "yes":
        venv_name = "{{ cookiecutter.venv_name }}"
        print(f"🐍 Creating virtual environment: {venv_name}")
        
        try:
            import subprocess
            result = subprocess.run(
                ["uv", "venv", venv_name], 
                capture_output=True, 
                text=True, 
                check=True
            )
            print(f"✅ Virtual environment '{venv_name}' created successfully")
            print(f"📋 Activate with: source {venv_name}/bin/activate")
            print("📦 Install dependencies with: uv sync --dev")
        except subprocess.CalledProcessError as e:
            print(f"❌ Failed to create virtual environment: {e}")
            print("💡 You can create it manually with: uv venv {{ cookiecutter.venv_name }}")
        except FileNotFoundError:
            print("❌ 'uv' command not found")
            print("💡 Install uv first: https://docs.astral.sh/uv/getting-started/installation/")
            print("💡 Or create manually with: python -m venv {{ cookiecutter.venv_name }}")
    else:
        print("ℹ️  Skipping virtual environment creation (not requested)")

def initialize_git_repository():
    """Initialize git repository if requested."""
    if "{{ cookiecutter.git_init }}" == "yes":
        print("🔧 Initializing git repository...")
        
        try:
            import subprocess
            
            # Initialize git repository
            subprocess.run(["git", "init"], capture_output=True, text=True, check=True)
            print("✅ Git repository initialized")
            
            # Add all files for initial commit
            subprocess.run(["git", "add", "."], capture_output=True, text=True, check=True)
            print("📁 Added all files to git staging")
            
            # Create initial commit
            commit_message = "Initial commit: {{ cookiecutter.project_name }} project scaffold\n\nGenerated from cookiecutter template with:\n- Python {{ cookiecutter.python_version }}\n- {{ cookiecutter.gitignore_profile }} gitignore profile\n- Max {{ cookiecutter.max_lines_per_file }} lines per file"
            
            subprocess.run(
                ["git", "commit", "-m", commit_message], 
                capture_output=True, 
                text=True, 
                check=True
            )
            print("📝 Created initial commit")
            
            # Set up main branch (modern git default)
            try:
                subprocess.run(
                    ["git", "branch", "-M", "main"], 
                    capture_output=True, 
                    text=True, 
                    check=True
                )
                print("🌿 Set default branch to 'main'")
            except subprocess.CalledProcessError:
                # Branch might already be main, or git version doesn't support -M
                pass
                
        except subprocess.CalledProcessError as e:
            print(f"❌ Git initialization failed: {e}")
            print("💡 You can initialize git manually with: git init && git add . && git commit -m 'Initial commit'")
        except FileNotFoundError:
            print("❌ 'git' command not found")
            print("💡 Install git first: https://git-scm.com/downloads")
    else:
        print("ℹ️  Skipping git initialization (not requested)")

def post_generation_workflow():
    """Execute post-generation workflow commands."""
    print("\n" + "="*60)
    print("🚀 EXECUTING POST-GENERATION WORKFLOW")
    print("="*60)
    
    # Change to the project directory (we're already in it after cookiecutter)
    project_dir = os.getcwd()
    project_name = "{{ cookiecutter.project_slug }}"
    
    print(f"📁 Working directory: {project_dir}")
    
    # Step 1: Activate virtual environment and install dependencies
    if "{{ cookiecutter.create_venv }}" == "yes":
        venv_name = "{{ cookiecutter.venv_name }}"
        venv_path = os.path.join(project_dir, venv_name)
        
        if os.path.exists(venv_path):
            print(f"🐍 Installing dependencies in virtual environment: {venv_name}")
            try:
                import subprocess
                result = subprocess.run(
                    ["uv", "sync", "--dev"], 
                    capture_output=True, 
                    text=True, 
                    check=True
                )
                print("✅ Dependencies installed successfully")
                print("📦 Virtual environment ready for development")
            except subprocess.CalledProcessError as e:
                print(f"⚠️  Failed to install dependencies: {e}")
                print("💡 You can install them manually with: uv sync --dev")
            except FileNotFoundError:
                print("⚠️  'uv' command not found for dependency installation")
                print("💡 Install dependencies manually after activating venv")
    
    # Step 2: Additional git operations if git was initialized
    if "{{ cookiecutter.git_init }}" == "yes":
        print("🔧 Performing additional git setup...")
        try:
            import subprocess
            
            # Check if there are any new files to add (shouldn't be, but just in case)
            result = subprocess.run(
                ["git", "status", "--porcelain"], 
                capture_output=True, 
                text=True, 
                check=True
            )
            
            if result.stdout.strip():
                print("📁 Found additional files to stage...")
                subprocess.run(["git", "add", "."], capture_output=True, text=True, check=True)
                subprocess.run(
                    ["git", "commit", "-m", "Post-generation: Add any remaining files"], 
                    capture_output=True, 
                    text=True, 
                    check=True
                )
                print("📝 Created additional commit for post-generation files")
            else:
                print("✅ Git repository is clean and up to date")
                
        except (subprocess.CalledProcessError, FileNotFoundError):
            # Git operations are optional, don't fail the whole process
            pass
    
    # Step 3: Final instructions
    print("\n" + "🎉 PROJECT SETUP COMPLETE! 🎉")
    print("="*60)
    print(f"📂 Project created: {project_name}")
    
    if "{{ cookiecutter.create_venv }}" == "yes":
        venv_name = "{{ cookiecutter.venv_name }}"
        print(f"🐍 Virtual environment: {venv_name}")
        print(f"   Activate with: source {venv_name}/bin/activate")
    
    if "{{ cookiecutter.git_init }}" == "yes":
        print("📚 Git repository: Initialized with initial commit")
        print("   Default branch: main")
    
    print(f"📖 Documentation: See CLAUDE.md for development instructions")
    print(f"🔧 Quality tools: ruff, mypy, custom linting configured")
    print(f"🤖 Claude Code hooks: Automatic quality checks enabled")
    
    print("\n" + "Next steps:")
    if "{{ cookiecutter.create_venv }}" == "yes":
        print(f"1. cd {project_name}")
        print(f"2. source {{ cookiecutter.venv_name }}/bin/activate")
        print("3. Start developing!")
    else:
        print(f"1. cd {project_name}")
        print("2. Create and activate virtual environment")
        print("3. Run: uv sync --dev")
        print("4. Start developing!")

def main():
    """Clean up conditional files based on cookiecutter choices."""
    
    # Always remove placeholder uv.lock - uv will generate the real one
    remove_file_if_exists("uv.lock")
    
    # Set up .gitignore based on selected profile
    setup_gitignore()
    
    # Create virtual environment if requested
    create_virtual_environment()
    
    # Initialize git repository if requested
    initialize_git_repository()
    
    # Clean up mkdocs files if not requested
    if "{{ cookiecutter.include_mkdocs }}" != "yes":
        remove_file_if_exists("mkdocs.yml")
        remove_dir_if_exists("docs")
    
    # Clean up LICENSE if not requested
    if "{{ cookiecutter.license }}" == "None":
        remove_file_if_exists("LICENSE")
    
    # Clean up packaging files if not requested
    if "{{ cookiecutter.include_packaging }}" != "yes":
        # Remove version from __init__.py
        init_file = "src/{{ cookiecutter.package_name }}/__init__.py"
        if os.path.exists(init_file):
            with open(init_file, 'r') as f:
                content = f.read()
            
            # Remove version line
            lines = content.split('\n')
            filtered_lines = [line for line in lines if not line.startswith('__version__')]
            
            with open(init_file, 'w') as f:
                f.write('\n'.join(filtered_lines))
            
            print(f"Removed version from {init_file}")
        
        # Simplify pytest config by removing coverage
        pyproject_file = "pyproject.toml"
        if os.path.exists(pyproject_file):
            with open(pyproject_file, 'r') as f:
                content = f.read()
            
            # Remove coverage-related pytest options
            content = content.replace(
                'addopts = [\n    "--cov=src/{{ cookiecutter.package_name }}",\n    "--cov-report=term-missing",\n    "--cov-report=html",\n    "--cov-fail-under=80",\n]',
                'addopts = []'
            )
            
            # Remove coverage sections
            lines = content.split('\n')
            filtered_lines = []
            skip_section = False
            
            for line in lines:
                if line.startswith('[tool.coverage'):
                    skip_section = True
                elif line.startswith('[') and skip_section:
                    skip_section = False
                    filtered_lines.append(line)
                elif not skip_section:
                    filtered_lines.append(line)
            
            with open(pyproject_file, 'w') as f:
                f.write('\n'.join(filtered_lines))
            
            print(f"Simplified pytest config in {pyproject_file}")
    
    # Show summary and get confirmation
    if not show_summary_and_confirm():
        return  # Project was deleted, exit
    
    # Execute post-generation workflow
    post_generation_workflow()

if __name__ == "__main__":
    main()