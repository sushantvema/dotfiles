const timestampFormatter = new Intl.DateTimeFormat(undefined, {
  year: "numeric",
  month: "2-digit",
  day: "2-digit",
  hour: "2-digit",
  minute: "2-digit",
  second: "2-digit",
  timeZoneName: "short",
})

function formatTimestamp() {
  return `[${timestampFormatter.format(new Date())}]`
}

function hasVisibleText(text) {
  return typeof text === "string" && text.trim().length > 0
}

export default async function MessageTimestampsPlugin() {
  const stampedMessages = new Set()

  return {
    // Prefix completed assistant text so timestamps are visible in the transcript.
    "experimental.text.complete": async (input, output) => {
      if (!hasVisibleText(output.text) || stampedMessages.has(input.messageID)) {
        return
      }

      stampedMessages.add(input.messageID)
      output.text = `${formatTimestamp()}\n\n${output.text}`
    },

    // Prefix tool titles so visible tool results show timing without duplicating body text.
    "tool.execute.after": async (_input, output) => {
      output.title = `${formatTimestamp()} ${output.title}`
    },
  }
}
