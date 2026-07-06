"use client";

import { useEffect, useRef } from "react";
import { Howl } from "howler";

const SOUNDS = {
  click: "https://actions.google.com/sounds/v1/ui/button_click.ogg",
  correct: "https://actions.google.com/sounds/v1/cartoon/wood_plank_flicks.ogg",
  wrong: "https://actions.google.com/sounds/v1/cartoon/cartoon_boing.ogg",
  victory: "https://actions.google.com/sounds/v1/cartoon/magic_chime_chord.ogg",
  tick: "https://actions.google.com/sounds/v1/foley/clock_ticking.ogg"
};

type SoundType = keyof typeof SOUNDS;

export function useAudio() {
  const players = useRef<Record<string, Howl>>({});

  useEffect(() => {
    // Preload sounds
    Object.entries(SOUNDS).forEach(([key, src]) => {
      players.current[key] = new Howl({ src: [src], preload: true, volume: 0.5 });
    });

    return () => {
      // Cleanup
      Object.values(players.current).forEach((howl) => howl.unload());
    };
  }, []);

  const play = (sound: SoundType, loop = false) => {
    const howl = players.current[sound];
    if (howl) {
      howl.loop(loop);
      howl.play();
    }
  };

  const stop = (sound: SoundType) => {
    const howl = players.current[sound];
    if (howl) {
      howl.stop();
    }
  };

  return { play, stop };
}
