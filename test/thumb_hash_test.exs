defmodule ThumbHashTest do
  use ExUnit.Case
  doctest ThumbHash

  test "generates a hash of an image" do
    waves = Path.join(__DIR__, "waves.jpg")
    waves_hash = "b8cJJIpJdnZaeIiQho1pf6b3Vg=="
    assert ThumbHash.generate_base64_hash!(waves) == waves_hash
  end

  test "generates a hash of an image with an alpha channel" do
    alpha_image = Path.join(__DIR__, "with-alpha.png")
    hash = "EmmOI4oPgod/h5egexP4ZwAAh4d4eIg="
    assert ThumbHash.generate_base64_hash!(alpha_image) == hash
  end

  test "generates a representative inline image from a hash" do
    waves_hash = "b8cJJIpJdnZaeIiQho1pf6b3Vg=="

    waves_inline =
      "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"

    assert ThumbHash.generate_base64_inline_image!(waves_hash) == waves_inline
  end

  test "generates a representative inline image from a hash (with alpha)" do
    alpha_hash = "EmmOI4oPgod/h5egexP4ZwAAh4d4eIg="

    alpha_inline =
      "iVBORw0KGgoAAAANSUhEUgAAACAAAAATCAYAAADxlA/3AAAACXBIWXMAAAPoAAAD6AG1e1JrAAAAtGVYSWZJSSoACAAAAAYAEgEDAAEAAAABAAAAGgEFAAEAAABWAAAAGwEFAAEAAABeAAAAKAEDAAEAAAACAAAAEwIDAAEAAAABAAAAaYcEAAEAAABmAAAAAAAAADhjAADoAwAAOGMAAOgDAAAGAACQBwAEAAAAMDIxMAGRBwAEAAAAAQIDAACgBwAEAAAAMDEwMAGgAwABAAAA//8AAAKgBAABAAAAIAAAAAOgBAABAAAAEwAAAAAAAABoRBc3AAAHsklEQVR4nEXUaWwb9AGG8b+gTUoO3/dtN3YOO03iHE7iOD5yp05c53B8xbmapEmahLRJE1a1jFbAyjg3ys2KgA0YDBgTDARTgU0UTVQgQGwIjWpo1TSKNKqNaqzAM6Ut2off5+f99Iq19gxrbZvSrEXSrIXTHAhl2Ahl+EFolMPhHEciE/yoY4rbu2a4u3eOB/sWeDS2yFMDSzw/tMRLw4u8NrLAm8k53k7Ncjq9mw8yk3ycHedMLsfZiVE+n8ry5UyWf+/J8p/5LBf3jvLN4ihitW2E1cgV4RFWQyOsBUdYDya5LpjmUCjDDZEcN7dPcFvnFHf3zPBAdA+PxuZ5Mr7Ac4MLvDS8wGuJOd5MznIqNc3p9CQfZMb5eDTHmbEsZycynNud4cvZDF/NZfh6IcM3ixm+XcoiVkJxLgletq81zv5AnLXAAOutQxwMJvhhKMmNbRl+3JHjJ90T3L9zikf6p3kiPsOzg7O8ODzDq4lp3khOcSo1wel0jg+yWT7OpTkznuLsVJJz00nO70lyYSHJfxdTfLuc4rtrU4jFQDeXtFy25O9m2d/Dir+XVf9ONgL9HGrdxZHwIMfaE9zRleLe3iw/68vx811jPDMwzm+GxnklMcbJkVHeSmV4J53i/ewIf84lODMxxNndQ3wxO8T5+SEuLA5zcXmYb1cSsC+BmG0KsGnPpsYAc75W5n2t7G0MsdwYYX9zOxstXRwO9nJjpI9bO+L8tHuQB3YmeLR/hKfiSZ4fTPLS8Ai/G0nw++QQf0wP8N5onD+Nxfh0Msbfpvs5Nxfj/N4YF5Z3cXFfnO9W47A2gBivr2HTRN0mL5O1XnbX1jJTV89cvY/Fhmb2NwW4riXE9cF2bop0cXtnL8d7ojwc7efxWIyn4zFeGOznleE+To5EeSvdy+lsDx+OdfPJZDefzXTzj/ke/rnYy1crO/l6Nco3B6J8t96HSFY7SVa7SFa5SFW5SFeVkq0qI1ddwWSNh5naKhbqvaw0NrDR0sz1wQA3t4W4o7ONe3raeTjaweOxTp6Od/DCYDuvJNp4PRnhVCbMu7kwH02G+ctMmLPzEc4ttXN+pYMLa518vd7FxY1uRL/byKZYhZFdFSbiFWYG3RaG3TZSlQ5Gq5xM1ZQzV+dhubGadX8dh4M+bmpr4rZOP8d7WnhoZ4DH+lv45a4Wfj3o5+XhZk4mmziVbeLd8WY+2t3Mp3MtnF0McG4lyJerIf61HuarjQiizSWnzaWg3amgw6mk06mi26VmZ6mW/jIDgxVmkpU2ctUlTNeVsdfnZtVfxcHWGo6Ea7mlvY67uuq4r6eOE9FaftFfy6/iXl4c9vJa0ssfRr28M1HHhzP1fLLg47PlJv6+z8/nay18caAF4bMX4LMX0mgvpMleRLO9mBa7hKBDTluJki6Xhmi5gQGPhVSVnfFaJ7MNZSw1VXCgxcOhYCVHI5Xc0u7hrk4P9/W4eSTq5olYBc8Nuvlt0sPro5W8PVnFu7M1fLRQyyfL9ZxZaeCv+30ItzmPS0z5eEz57DBvo9pcgNdSRINNSrNDQbBETUepnmiFiYEdNlI1DsbrSpj1uVhqKmXVX8rBgIsjISfHIk7u7Cjh3p4STvSV8OSAk+dHSnk5W87rE25OTe/gnblq3ttbw/uLXoRFv4XvWfVbsenzcOi34TQUUGYqptIiw2tT4tuuIeDS015motdtJb7Dzki1g1Gvg911DuYb7FzbaGPdb+Vwq4WbwhZu77ByT6+NEzEHTwyV8FzaxYu5cl6ddHNyupI3ZisRcvUWLtuKQr0VpToftWYbOm0BRl0RVoOUEpOCcouaKruO+u1G/C4z4TILXRVWoh4rA5UWklVmcjUmpmuN7K03sL/JwMGAgaMRI7d2mbk7auWhAQePJZw8mS7lmdEynh0rR2xR5rFFkcdWRT55inzyFdu4RllAoaoIiVqCQiNHo1NiNGiwmfS4LEbcNhM1DjMNJWZanGbCLhOdpQai5XoGKrSkKjWMV2vYU6fh2iYd17XquaHNxLEeC3f22zk+sJ37h508mHAhhOwaLiu4ohAhK0bIJVylkLNVqeQatRqJRodSZ0BnMGE2mnGYzZRazHgsJmqsRhpsevx2LWGHmi6niv4yJQmPkly1mpl6DUt+PQdCRg51WDjaY+PmqINj/dsRQlrMJZJNEoREipDIEFIFQqpCyDQIhY6rlQby1SaKNGZkWgtqnQW9zoxFb8KhN1Cq1+ExaKgxqvCZFbTa5HSUyOkrU5CoVJGr1TDTqGcxYGJf2MKBdhsbnXaEKJZxmfwKBaJYiShWIyRahESHkBoQchNCYeEqpZU8lZUClRWJyoJCZUKjMmBUabGq1ZRolFRo5dQYZDRaZIQccrpLFezyqEl6tYz5DEz7Tcy1WlgIWjcHKBFF31MhitSIIg2iSIso0iOKjQiJCSG1IGRWhNx2ydVyG/lyKwVyMxK5AYVci0auwqhQYFfKKNVIqdJLaTDLLn1KV5mKWKWGhFdPpsHIWJOZCb8F8f/oFYUaRKEWUahHFBkQRSZEsQUhsSKkNoTUjpBtsnG1zEqe1EyB1IBEqkUhVaGVKjDJZWxXSqnQSvEapTTb5EScSnrdGuLVOhJ1RtI+M9lGM/8DD4xlQMFolkcAAAAASUVORK5CYII="

    assert ThumbHash.generate_base64_inline_image!(alpha_hash) == alpha_inline
  end
end
