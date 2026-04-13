import {Composition} from 'remotion';
import {OnboardingWalkthrough} from './OnboardingWalkthrough';

export const RemotionRoot: React.FC = () => {
  return (
    <>
      <Composition
        id="OnboardingWalkthrough"
        component={OnboardingWalkthrough}
        durationInFrames={540} // 18 seconds at 30fps
        fps={30}
        width={780}
        height={1768}
        defaultProps={{}}
      />
    </>
  );
};
