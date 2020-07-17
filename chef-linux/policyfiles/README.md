# Policyfiles

Create Policyfiles here. When using a chef-repo, give your Policyfiles
the same filename as the name set in the policyfile itself, and use the
`.rb` file extension.

Compile the policy with a command like this:

```bash
chef install policyfiles/my-app-frontend.rb
```

This will create a lockfile `policyfiles/my-app-frontend.lock.json`.

To update locked dependencies, run `chef update` like this:

```bash
chef update policyfiles/my-app-frontend.rb
```

You can upload the policy (with associated cookbooks) to the server
using a command like:

```bash
chef push staging policyfiles/my-app-frontend.rb
```
