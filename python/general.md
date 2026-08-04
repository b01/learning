# Python in General

I have a good grip on Python already, so I'm not gonna write a book here. This
is just for things I often need to refresh quickly when I haven't used it
in a while.

I often use Python in a container, so I don't use `venv` much if I can help it.
Though it is not that hard to understand and use. But these notes are written in
the context that you are installing directly on the machine. Since a container
isolates it to some degree, you can avoid venv and managing them. If you need
a new environment, then just make a new image and container.

## Requirements

Making a requirement file from an existing project.

```shell
python3 -m pip freeze > requirements.txt
```

## Entrypoint

You can give your Python application an entrypoint. Such as a main function
in other languages.

```python
#!/usr/bin/env python3

if __name__ == '__main__':
    print_hi('PyCharm')
```

NOTE: We also can provide a shell header (a.k.a shebang).