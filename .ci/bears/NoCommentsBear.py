import re

from coalib.bears.LocalBear import LocalBear
from coalib.results.Diff import Diff
from coalib.results.Result import Result
from coalib.results.RESULT_SEVERITY import RESULT_SEVERITY


class NoCommentsBear(LocalBear):
    LANGUAGES = {'Python', 'bash', 'dash', 'ksh', 'sh'}
    AUTHORS = {'The coala developers'}
    AUTHORS_EMAILS = {'coala-devel@googlegroups.com'}
    LICENSE = 'AGPL-3.0'
    CAN_DETECT = {'Comments'}

    def run(self, filename, file):
        """
        Check for shell-style comments in the file.
        """
        corrected = []
        for line in file:
            comments = r'#(?!!).*'
            if not re.match(comments, line):
                corrected += [line]
        diffs = Diff.from_string_arrays(file, corrected).split_diff()
        for diff in diffs:
            yield Result(self,
                         'Comments are not allowed',
                         affected_code=(diff.range(filename),),
                         diffs={filename: diff},
                         severity=RESULT_SEVERITY.MAJOR)
