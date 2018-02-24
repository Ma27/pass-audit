#!/usr/bin/env bash
# pass audit - Password Store Extension (https://www.passwordstore.org/)
# Copyright (C) 2018 Alexandre PUJOL <alexandre@pujol.io>.
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.
#

readonly CMD="audit"
readonly LIBDIR="${PASSWORD_STORE_LIBDIR:-/usr/lib/password-store/$CMD}"
readonly Bold='\e[1m' Bred='\e[1;31m' reset='\e[0m'
_error() { echo -e " ${Bred}[x]${reset} ${Bold}Error:${reset} ${*}" >&2; }
_die() { _error "${@}" && exit 1; }
_ensure_dependencies() {
	command -v "python3" &>/dev/null || _die "$PROGRAM $COMMAND requires python3"
	[[ -f "${LIBDIR}/${CMD}.py" ]] || _die "$PROGRAM $COMMAND requires ${LIBDIR}/$CMD.py"
}

cmd_audit() {
	export PASSWORD_STORE_DIR=$PREFIX GIT_DIR PASSWORD_STORE_GPG_OPTS
	export X_SELECTION CLIP_TIME PASSWORD_STORE_UMASK GENERATED_LENGTH
	export CHARACTER_SET CHARACTER_SET_NO_SYMBOLS EXTENSIONS PASSWORD_STORE_KEY
	export PASSWORD_STORE_ENABLE_EXTENSIONS PASSWORD_STORE_SIGNING_KEY
	export GNUPGHOME LIBDIR PYTHONIOENCODING="UTF-8" PASSWORD_STORE_BIN="$0"
	python3 "${LIBDIR}/${CMD}.py" "$@"
	return $?
}

_ensure_dependencies
cmd_audit "$@"
exit $?
