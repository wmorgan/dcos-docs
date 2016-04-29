# Contributing to the DC/OS Documentation

Use these guidelines to contribute to the DC/OS documentation.

## Format guidelines

Markdown in this repository is formatted for rendering by using [Metalsmith](http://www.metalsmith.io/).

- Links must include the full directory path, including version, relative to the root of dcos.io (e.g. `/docs/1.7/administration/sshcluster/`). Note that these links will not work in the GitHub code browser. It is recommended that you test your content [locally](#test-local) before submitting your PR.
- Final page links are directory names, not filenames (e.g. `https://dcos.io/docs/latest/usage/service-discovery/mesos-dns/`).
- You must have an `index.md` page for all parent directories (rather than using Github's README.md indexing). For example, the parent directory `/dcos-docs/1.7/administration/` must also contain `/dcos-docs/1.7/index.md`.
- The table of contents of each page is automatically generated based on the top-level headers.
- Directory tables of contents are automatically generated based on `post_title` and `post_excerpt` headers.

## Style guidelines

- Use active voice wherever possible, which tells who or what is performing the action.
- Use sentence-style capitalization for headings in most cases.

## Make your update

1. Create a [new issue](https://github.com/dcos/dcos-docs/issues) in this repo (`dcos-docs`) and label it with the type of documentation that you're writing. For example, [tutorial](https://github.com/dcos/dcos-docs/labels/tutorial).
1. [Fork](https://help.github.com/articles/fork-a-repo/) this repo, `dcos-docs` (you only have to do this once).
1. Create your content. In most cases you should be able to create your content within the existing directory structure. 

    - To create a single page:
        1. Create a markdown file `{post_slug}.md` where `post_slug` is your file name. File names become URIs. If you want this page to be a child of another page, place the `.md` file in the parent folder.
        1. Add your page content, including the required metadata (`post_title`, `nav_title`, `menu_order`). Do not include any other metadata.
        
               ```
               ---
               post_title: The Title
               ---
               Post markdown goes here.
               ```
    - To create a page with hierarchy:
        1. Create a new directory in the appropriate location of the correctly versioned release (e.g. `/1.7/foo`) and a child page within this folder named `index.md` (e.g. `/1.7/foo/index.md`). The actual URL of your page will be `/1.7/foo/`, not `/1.7/foo/index`. For example, if it's a tutorial for 1.7, create a new directory here `/1.7/usage/tutorials/foo/`.
        1. Add your page content, including the required metadata (`post_title`, `nav_title`, `menu_order`). Do not include any other metadata.
                
               ```
               ---
               post_title: The Title
               ---
               Post markdown goes here.
               ```

    **Tip:** There are templates available for some content types. For example, if it's a tutorial you can copy [templates/tutorial.md](templates/tutorial.md) into `foo/` and rename it to `foo/index.md`. Adapt the sections in your new `foo/index.md` to the specifics of your content.
1. Add images in a child `foo/img/` directory.  
1. Include all required assets in your `/foo` directory, for example, Marathon app spec, JSON docs, or a Dockerfile.


If you're unsure about what exactly should go into the tutorial, you can always check out [spark/](/1.7/usage/tutorials/spark/) for reference.

## <a name="test-local"></a>Test your content locally

1. [Create a repo fork in GitHub](https://guides.github.com/activities/forking/)
1. [Clone the dcos/dcos-website repo](https://help.github.com/articles/cloning-a-repository/)
1. Add repo fork as remote repo:

    ```
    git remote add fork https://github.com/<github-user>/dcos-website
    git fetch fork
    ```
1. Checkout the develop branch:

    ```
    git checkout develop
    ```
1. Update the dcos-docs submodule:

    ```
    git submodule update --init --recursive
    ```
1. [Install Node](https://docs.npmjs.com/getting-started/installing-node)
1. Install dependencies:

    ```
    npm install
    ```
1. Launch local dev server:

    ```
    npm start
    ```
    (opens dev server in browser)
    
## Submit a pull request

1. When you're done, submit a [pull request](https://help.github.com/articles/using-pull-requests/) to the original repo, `dcos-docs`.
1. For all contributions that include hands-on instructions, such as found in `usage/` or `administration/`, the community managers will test-drive and validate before merging. They might come back to you asking you to fix things. All communication strictly via your pull request on GitHub.  
