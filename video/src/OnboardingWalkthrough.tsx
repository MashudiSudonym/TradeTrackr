import {
  AbsoluteFill,
  interpolate,
  useCurrentFrame,
  useVideoConfig,
  spring,
  Audio,
  staticFile,
} from 'remotion';
import {css} from '@remotion/css';

// Screen data with timing
const screens = [
  {
    id: 'discipline',
    title: 'Catat Setiap Trade',
    subtitle: 'Disiplin adalah kunci sukses.',
    image: 'onboarding-discipline-gradient.png',
    duration: 180, // 6 seconds
  },
  {
    id: 'analysis',
    title: 'Analisis Mendalam',
    subtitle: 'Pahami kekuatan dan kelemahan.',
    image: 'onboarding-analysis.png',
    duration: 180, // 6 seconds
  },
  {
    id: 'progress',
    title: 'Tumbuh Setiap Hari',
    subtitle: 'Lacak progres Anda.',
    image: 'onboarding-progress.png',
    duration: 180, // 6 seconds
  },
];

const ScreenSlide: React.FC<{
  screen: typeof screens[0];
  startTime: number;
  endTime: number;
}> = ({screen, startTime, endTime}) => {
  const frame = useCurrentFrame();
  const {fps} = useVideoConfig();

  // Calculate progress through this slide (0 to 1)
  const slideProgress = interpolate(
    frame,
    [startTime, endTime - 30],
    [0, 1],
    {extrapolateRight: 'clamp'}
  );

  // Zoom effect: subtle scale from 1 to 1.05
  const scale = spring({
    frame: frame - startTime,
    fps,
    config: {
      damping: 12,
      stiffness: 40,
      mass: 1,
    },
  });

  // Fade in effect
  const opacity = interpolate(
    frame,
    [startTime, startTime + 15],
    [0, 1],
    {extrapolateLeft: 'clamp'}
  );

  // Fade out effect
  const fadeOut = interpolate(
    frame,
    [endTime - 15, endTime],
    [1, 0],
    {extrapolateRight: 'clamp'}
  );

  // Text animation - slide up and fade in
  const textY = interpolate(
    frame,
    [startTime, startTime + 30],
    [50, 0],
    {extrapolateLeft: 'clamp'}
  );

  const textOpacity = interpolate(
    frame,
    [startTime + 10, startTime + 25],
    [0, 1],
    {extrapolateLeft: 'clamp', extrapolateRight: 'clamp'}
  );

  return (
    <AbsoluteFill
      style={{
        opacity: opacity * fadeOut,
        backgroundColor: '#f9f9f9',
      }}
    >
      {/* Background gradient */}
      <AbsoluteFill
        style={{
          background: `radial-gradient(circle at 50% 30%, #f9f9f9 0%, #ffdada 60%, #f9f9f9 100%)`,
        }}
      />

      {/* Screen image with zoom */}
      <div
        style={{
          position: 'absolute',
          top: '50%',
          left: '50%',
          transform: `translate(-50%, -50%) scale(${0.95 + scale * 0.1})`,
          width: '100%',
          height: '100%',
          display: 'flex',
          alignItems: 'center',
          justifyContent: 'center',
        }}
      >
        <img
          src={staticFile(screen.image)}
          style={{
            width: '100%',
            height: '100%',
            objectFit: 'contain',
          }}
        />
      </div>

      {/* Bottom gradient overlay for text readability */}
      <AbsoluteFill
        style={{
          background: 'linear-gradient(to top, rgba(249, 249, 249, 0.95) 0%, transparent 40%)',
        }}
      />

      {/* Text overlay */}
      <div
        style={{
          position: 'absolute',
          bottom: '200px',
          left: '40px',
          right: '40px',
          transform: `translateY(${textY}px)`,
          opacity: textOpacity,
        }}
      >
        <h2
          style={{
            fontFamily: 'Manrope',
            fontWeight: 700,
            fontSize: '28px',
            color: '#2d3435',
            marginBottom: '12px',
            textShadow: '0 2px 8px rgba(255, 255, 255, 0.8)',
          }}
        >
          {screen.title}
        </h2>
        <p
          style={{
            fontFamily: 'Inter',
            fontWeight: 400,
            fontSize: '16px',
            color: '#5a6061',
            textShadow: '0 1px 4px rgba(255, 255, 255, 0.8)',
          }}
        >
          {screen.subtitle}
        </p>
      </div>

      {/* Page indicator */}
      <div
        style={{
          position: 'absolute',
          bottom: '120px',
          left: '50%',
          transform: 'translateX(-50%)',
          display: 'flex',
          gap: '12px',
        }}
      >
        {screens.map((s, i) => (
          <div
            key={s.id}
            style={{
              width: s.id === screen.id ? '24px' : '8px',
              height: '8px',
              borderRadius: '4px',
              backgroundColor: s.id === screen.id ? '#be0038' : '#e4e9ea',
              transition: 'all 0.3s ease',
            }}
          />
        ))}
      </div>
    </AbsoluteFill>
  );
};

const BrandingEndCard: React.FC = () => {
  const frame = useCurrentFrame();
  const {fps} = useVideoConfig();

  // Fade in
  const opacity = interpolate(frame, [510, 525], [0, 1], {
    extrapolateLeft: 'clamp',
  });

  // Scale effect
  const scale = spring({
    frame: frame - 510,
    fps,
    config: {damping: 15, stiffness: 50},
  });

  return (
    <AbsoluteFill
      style={{
        opacity,
        background: `radial-gradient(circle at 50% 50%, #ffdada 0%, #f9f9f9 100%)`,
        display: 'flex',
        flexDirection: 'column',
        alignItems: 'center',
        justifyContent: 'center',
      }}
    >
      <div
        style={{
          transform: `scale(${0.9 + scale * 0.1})`,
          textAlign: 'center',
        }}
      >
        <h1
          style={{
            fontFamily: 'Manrope',
            fontWeight: 800,
            fontSize: '48px',
            color: '#be0038',
            marginBottom: '16px',
          }}
        >
          TradeTrackr
        </h1>
        <p
          style={{
            fontFamily: 'Inter',
            fontWeight: 600,
            fontSize: '24px',
            color: '#2d3435',
            letterSpacing: '2px',
          }}
        >
          YOUR TRADING JOURNAL
        </p>
      </div>
    </AbsoluteFill>
  );
};

export const OnboardingWalkthrough: React.FC = () => {
  const {durationInFrames} = useVideoConfig();

  // Calculate timing for each screen
  let currentTime = 0;
  const screenTimings = screens.map(screen => {
    const start = currentTime;
    const end = currentTime + screen.duration;
    currentTime = end;
    return {screen, start, end};
  });

  return (
    <AbsoluteFill style={{backgroundColor: '#f9f9f9'}}>
      {screenTimings.map(({screen, start, end}) => (
        <ScreenSlide
          key={screen.id}
          screen={screen}
          startTime={start}
          endTime={end}
        />
      ))}

      {/* End branding card */}
      <BrandingEndCard />
    </AbsoluteFill>
  );
};
