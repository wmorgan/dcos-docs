# Contributing to the DC/OS Documentation

Use these guidelines to contribute to the DC/OS documentation:

1. Create a [new issue](https://github.com/dcos/dcos-docs/issues) in this repo (`dcos-docs`) and label it with the type of documentation that you're writing. For example, [tutorial](https://github.com/dcos/dcos-docs/labels/tutorial).
1. [Fork](https://help.github.com/articles/fork-a-repo/) this repo, `dcos-docs` (you only have to do this once).
1. Create your content.

    - To create a single page:
        1. Create a markdown file `{post_slug}.md` where `post_slug` is your file name. File names become URIs. If you want this page to be a child of another page, place the `.md` file in the parent folder.
        1. Add your page content, including the required metadata (`post_title`, `nav_title`, `menu_order`). Do not include any other metadata.
        
               ```
               ---
               post_title: The Title
               nav_title: The Title
               menu_order: 1
               ---
               Post markdown goes here.
               ```
    - To create a page with hierarchy:
        1. Create a new directory in the appropriate location of the correctly versioned release (e.g. `/1.7/foo`) and a child page within this folder named `index.md` (e.g. `/1.7/foo/index.md`). The actual URL of your page will be `/1.7/foo/`, not `/1.7/foo/index`. For example, if it's a tutorial for 1.7, create a new directory here `/1.7/usage/tutorials/foo/`.
        1. Add your page content, including the required metadata (`post_title`, `nav_title`, `menu_order`). Do not include any other metadata.
                
               ```
               ---
               post_title: The Title
               nav_title: The Title
               menu_order: 1
               ---
               Post markdown goes here.
               ```

    **Tip:** There are templates available for some content types. For example, if it's a tutorial you can copy [templates/tutorial.md](templates/tutorial.md) into `foo/` and rename it to `foo/index.md`. Adapt the sections in your new `foo/index.md` to the specifics of your content.
1. Add images in a child `foo/img/` directory.  
1. Include all required assets in your `/foo` directory, for example, Marathon app spec, JSON docs, or a Dockerfile.
1. When you're done, submit a [pull request](https://help.github.com/articles/using-pull-requests/) to the original repo, `dcos-docs`.
1. For all contributions that include hands-on instructions, such as found in `usage/` or `administration/`, the community managers will test-drive and validate before merging. They might come back to you asking you to fix things. All communication strictly via your pull request on GitHub.  

If you're unsure about what exactly should go into the tutorial, you can always check out [spark/](/1.7/usage/tutorials/spark/) for reference.
