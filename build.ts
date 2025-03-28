import { type Build } from 'xbuild';

const build: Build = {
    common: {
        project: 'snappy',
        archs: ['x64'],
        variables: [],
        copy: {},
        defines: [],
        options: [
            ['SNAPPY_BUILD_TESTS', false],
            ['SNAPPY_BUILD_BENCHMARKS', false]
        ],
        subdirectories: ['snappy'],
        libraries: {
            snappy: {}
        },
        buildDir: 'build',
        buildOutDir: '../libs',
        buildFlags: []
    },
    platforms: {
        win32: {
            windows: {},
            android: {
                archs: ['x86', 'x86_64', 'armeabi-v7a', 'arm64-v8a'],
            }
        },
        linux: {
            linux: {}
        },
        darwin: {
            macos: {}
        }
    }
}

export default build;