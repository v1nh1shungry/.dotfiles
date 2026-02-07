export const NotificationPlugin = async ({ project, client, $, directory, worktree }) => {
  const TITLE = "🤖 OpenCode";
  const MSG_DONE = "🥳 Done!";
  const MSG_WAITING = "🥺 Waiting for your approval...";

  return {
    event: async ({ event }) => {
      if (event.type === "session.idle") {
        await $`notify-send ${TITLE} ${MSG_DONE}`;
      } else if (event.type === "permission.asked") {
        await $`notify-send ${TITLE} ${MSG_WAITING}`;
      }
    },
  };
};
