#! /usr/bin/env python3
# -*- coding: utf-8 -*-

import argparse
import pathlib
import re


def main():
    #Parse argument
    parser = argparse.ArgumentParser(description="Genetate resource list.")
    parser.add_argument("-c",
                        "--changelog",
                        type=str,
                        required=False,
                        default=None,
                        help="Changelog file.")
    parser.add_argument("-o",
                        "--output",
                        type=str,
                        required=True,
                        help="Output file.")
    parser.add_argument("-r",
                        "--root",
                        type=str,
                        required=True,
                        help="Root directory.")
    parser.add_argument("-s",
                        "--source_dir",
                        type=str,
                        required=True,
                        help="Source directory.")
    parser.add_argument("-i", "--indent", type=int, default=0, help="Indent.")
    parser.add_argument("inputs", type=str, nargs='+', help="Input files.")

    args = parser.parse_args()
    args.output = pathlib.Path(args.output).absolute()
    args.root = pathlib.Path(args.root).absolute()
    args.source_dir = pathlib.Path(args.source_dir).absolute()

    # Write .qrc file
    print("%s-- Generating file \"%s\"..." %
          (" " * (args.indent), str(args.output.relative_to(args.source_dir))))
    with open(str(args.output), "wb") as f:
        f.write("<RCC>\n".encode(encoding="utf-8"))
        f.write("    <qresource prefix=\"/\">\n".encode(encoding="utf-8"))

        for path in args.inputs:
            path = pathlib.Path(path).absolute()
            relpath = path.relative_to(args.root)
            f.write(("        <file >%s</file>\n" %
                     (str(relpath))).encode(encoding="utf-8"))
            print("%s-- \"%s\" : \"%s\" -> \"%s\"" %
                  (" " * (args.indent + 4),
                   str(args.output.relative_to(args.source_dir)),
                   str(path.relative_to(args.source_dir)), str(relpath)))

        if args.changelog:
            root_relpath = args.root.relative_to(args.source_dir)
            root_relpath = pathlib.Path(
                re.sub("[^/]+", "..", str(root_relpath)))
            relpath = pathlib.Path(args.changelog).absolute().relative_to(
                args.source_dir)

            f.write(("        <file alias=\"%s\">%s</file>\n" %
                     ("Text/changelog", str(root_relpath / relpath))).encode(
                         encoding="utf-8"))
            print(
                "%s-- \"%s\" : \"%s\" -> \"Text/changelog\"" %
                (" " * (args.indent + 4),
                 str(args.output.relative_to(args.source_dir)), str(relpath)))

        f.write("    </qresource>\n".encode(encoding="utf-8"))
        f.write("</RCC>".encode(encoding="utf-8"))

    return 0


if __name__ == "__main__":
    exit(main())
