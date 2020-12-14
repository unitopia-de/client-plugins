import tf, json

def escape(s):
    return s.replace('\\', '\\\\').replace('"', '\\"')

last_kbhead = None

def handle_gmcp(args):
    args = args.split(' ', 1)
    msg = args[0].lower()
    if msg == 'input.completetext':
        # Input.CompleteText "replacement"
        #
        # Contains the full text to replace
        # the current text up to the cursor.
        old = tf.eval("/test kbhead()")
        if old != last_kbhead:
            return
        new = json.loads(args[1])

        # Check which part we have to replace
        # (Ignore common prefix of the old and new string)
        if new[:len(old)] == old:
            i = len(old)
        else:
            for i in range(len(old)):
                if new[i] != old[i]:
                    break

        # Translate the position to bytes.
        tfi = len(old[:i].encode("UTF-8"))
        pos = tf.eval("/test kbpoint()")
        if tfi != pos:
            tf.eval("/test kbdel(%d)" % tfi)
        tf.eval("/input " + escape(new[i:]))
    elif msg == 'input.completechoice':
        # Input.CompleteChoice [ "choices", ... ]
        #
        # Contains a list of choices to display.
        # The strings only contain suggestions for the last
        # word (characters since the last whitespace).
        words = json.loads(args[1])
        width = max(len(word) for word in words) + 1
        screen = tf.eval("/test columns()")

        cols = max(1, (screen+1) // (width+1))
        lines = (len(words) + cols - 1) // cols
        width = max(width+1, (screen + 1) // cols)

        for line in range(lines):
            s = ""
            for col in range(min(cols, (len(words) - line + lines - 1) // lines)):
                s += words[line + col*lines].ljust(width)
            tf.out(s.rstrip())
    elif msg == 'input.completenone':
        # Input.CompleteNone
        #
        # There is no suggestion.
        tf.eval("/beep")

def handle_tab(args):
    # Tab was pressed, ask for suggestions.
    global last_kbhead
    last_kbhead = tf.eval("/test kbhead()")
    tf.eval(escape('/test gmcp("input.complete ' + escape(json.dumps(last_kbhead)) + '")'))

def start_gmcp(args):
    # New world connected, register the package.
    tf.eval(escape('/test gmcp("core.supports.add [ \\"input 1\\" ]")'))

tf.eval('/hook GMCP input.complete* = /python_call complete.handle_gmcp \\%*')
tf.eval('/hook CONNECT = /python_call complete.start_gmcp')
tf.eval('/def key_tab = /python_call complete.handle_tab')
