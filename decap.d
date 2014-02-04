import std.regex, std.stdio, std.conv, std.algorithm, std.array, std.string;

void main(string args[])
{
	// Compile in a regex to recognize emails
	auto emailRegex = ctRegex!(`[\w.]+@\w+\.(?:edu|com)`);
	string line;
	while ((line = stdin.readln()) !is null) {
		if (line.length == 1) { // Ignore empty lines (they'll only contain a newline)
			assert(line[0] == '\n');
			writeln();
			continue;
		}

		// Match the email
		auto emailMatch = matchFirst(line, emailRegex);
		// Chop off everything before the comma
		string[] nameParts = split(split(line, ",")[0]);

		// Chop off the email address if there was no comma
		if (any!((c) { return c == '@'; })(nameParts[$-1]))
			nameParts = nameParts[0..$-1];

		foreach (ref part; nameParts) {
			// Only mess with totally capitalized names. We'll handle Mc__ and von __ ourselves
			if (all!((c) { return c >= 'A' && c <= 'Z'; })(part))
				part = part[0] ~ part[1..$].toLower();
		}

		line = join(nameParts, " ");

		if (emailMatch.empty)
			line ~= ", BAD EMAIL";
		else
			line ~= ", " ~ emailMatch[0];

		writeln(line);
	}
}
