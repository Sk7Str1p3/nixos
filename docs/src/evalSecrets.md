# Evaluation time secrets

Some secrets cannot be left in cleartext (e.g time zone, user's real names), but are required at evaluation time,
and in some cases using sops-nix's template is really inconvenient.
To handle this, __currently__ i use strange approach: I manually encrypt files with sops, commit them and manually decrypt.
[git-agecrypt](https://github.com/vlaci/git-agecrypt) wasn't suitable for me.
In future, i will replace it with my own implementation of transparent git encryption based on sops.

Also, this used only for secrets which may be safely left in world-readable store. For more sensitive secrets I use `sops-nix`, which decrypts secrets only at runtime.
